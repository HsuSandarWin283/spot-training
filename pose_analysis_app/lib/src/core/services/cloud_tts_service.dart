import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:edge_tts/edge_tts.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

class CloudTtsService {
  static const String _myanmarVoice = 'my-MM-NilarNeural';
  static const String _englishVoice = 'en-US-AvaNeural';

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    _player.onPlayerComplete.listen((_) {
      _isPlaying = false;
    });

    _initialized = true;
    debugPrint('CloudTtsService: initialized (Edge TTS - free)');
  }

  bool get isPlaying => _isPlaying;

  Future<void> speak({
    required String text,
    String languageCode = 'my-MM',
  }) async {
    if (text.trim().isEmpty || !_initialized) return;

    if (_isPlaying) {
      await stop();
    }

    final voice = languageCode.startsWith('my') ? _myanmarVoice : _englishVoice;

    try {
      final cacheKey = _getCacheKey(text, voice);
      final cachedFile = await _getCachedAudio(cacheKey);

      if (cachedFile != null) {
        debugPrint('CloudTts: cache hit');
        await _playFile(cachedFile);
        return;
      }

      debugPrint('CloudTts: generating "$text" with voice $voice');
      final bytes = await _generateAudio(text, voice);

      if (bytes != null && bytes.isNotEmpty) {
        await _cacheAudio(cacheKey, bytes);
        await _playBytes(bytes);
        debugPrint('CloudTts: playing (${bytes.length} bytes)');
      } else {
        debugPrint('CloudTts: no audio generated');
      }
    } catch (e) {
      debugPrint('CloudTts: error: $e');
    }
  }

  Future<void> stop() async {
    _isPlaying = false;
    await _player.stop();
  }

  Future<Uint8List?> _generateAudio(String text, String voice) async {
    final communicate = Communicate(
      text: text,
      voice: voice,
      rate: '+0%',
      pitch: '+0Hz',
      volume: '+0%',
    );

    final audioChunks = <int>[];
    await for (final event in communicate.stream()) {
      if (event is AudioDataEvent) {
        audioChunks.addAll(event.data);
      }
    }

    return audioChunks.isNotEmpty ? Uint8List.fromList(audioChunks) : null;
  }

  Future<void> _playBytes(Uint8List bytes) async {
    _isPlaying = true;
    await _player.play(BytesSource(bytes));
  }

  Future<void> _playFile(File file) async {
    _isPlaying = true;
    await _player.play(DeviceFileSource(file.path));
  }

  String _getCacheKey(String text, String voice) {
    final hash = md5.convert(utf8.encode('$text|$voice'));
    return hash.toString();
  }

  Future<File?> _getCachedAudio(String key) async {
    try {
      final dir = await _getCacheDir();
      final file = File('${dir.path}/tts_$key.mp3');
      if (await file.exists()) {
        final age = DateTime.now().difference(await file.lastModified());
        if (age < const Duration(days: 7)) {
          return file;
        }
        await file.delete();
      }
    } catch (_) {}
    return null;
  }

  Future<void> _cacheAudio(String key, Uint8List bytes) async {
    try {
      final dir = await _getCacheDir();
      final file = File('${dir.path}/tts_$key.mp3');
      await file.writeAsBytes(bytes);
    } catch (e) {
      debugPrint('CloudTts: cache error: $e');
    }
  }

  Future<Directory> _getCacheDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${appDir.path}/tts_cache');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  void dispose() {
    _player.dispose();
    _initialized = false;
  }
}
