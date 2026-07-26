import 'package:flutter/foundation.dart';
import 'package:ai_sports_training/src/core/services/cloud_tts_service.dart';

class VoiceCoachingService {
  final CloudTtsService _cloudTts;
  String _lastSpokenMessage = '';
  bool _enabled = true;
  bool _initialized = false;

  VoiceCoachingService({CloudTtsService? cloudTts})
      : _cloudTts = cloudTts ?? CloudTtsService();

  Future<void> init() async {
    if (_initialized) return;

    try {
      await _cloudTts.init();
      _initialized = true;
      debugPrint('VoiceCoaching: initialized with Cloud TTS');
    } catch (e) {
      debugPrint('VoiceCoaching: init error: $e');
      _initialized = true;
    }
  }

  void setEnabled(bool enabled) {
    _enabled = enabled;
    if (!enabled) {
      _cloudTts.stop();
    }
  }

  bool get isEnabled => _enabled;

  bool get isSpeaking => _cloudTts.isPlaying;

  Future<void> speakFeedback(List<String> corrections) async {
    if (!_enabled || _cloudTts.isPlaying || corrections.isEmpty || !_initialized) return;

    final newMessage = corrections.first;
    if (newMessage == _lastSpokenMessage) return;

    _lastSpokenMessage = newMessage;

    final text = _toMyanmar(newMessage);
    debugPrint('VoiceCoaching: speaking "$text"');
    await _cloudTts.speak(text: text, languageCode: 'my-MM');
  }

  Future<void> speakSuccess() async {
    if (!_enabled || _cloudTts.isPlaying || !_initialized) return;
    _lastSpokenMessage = '';
    debugPrint('VoiceCoaching: speaking success');
    await _cloudTts.speak(
      text: 'အလွန်ကောင်းပါသည်',
      languageCode: 'my-MM',
    );
  }

  Future<void> speakStepComplete(int stepNumber) async {
    if (!_enabled || _cloudTts.isPlaying || !_initialized) return;
    _lastSpokenMessage = '';
    debugPrint('VoiceCoaching: speaking step complete');
    await _cloudTts.speak(
      text: 'နောက်တစ်ဆင့်သို့ ဆက်သွားနိုင်ပါပြီ',
      languageCode: 'my-MM',
    );
  }

  Future<void> speakExerciseComplete() async {
    if (!_enabled || _cloudTts.isPlaying || !_initialized) return;
    _lastSpokenMessage = '';
    debugPrint('VoiceCoaching: speaking exercise complete');
    await _cloudTts.speak(
      text: 'လေ့ကျင့်ခန်း ပြီးဆုံးပါပြီ။ ကျေးဇူးတင်ပါသည်',
      languageCode: 'my-MM',
    );
  }

  String _toMyanmar(String english) {
    switch (english) {
      case 'Raise your left arm':
        return 'ဘယ်ဘက်လက်ကို အပေါ်ဘက် မြှောက်ပါ';
      case 'Lower your left arm':
        return 'ဘယ်ဘက်လက်ကို အောက်ချပါ';
      case 'Raise your right arm':
        return 'ညာဘက်လက်ကို အပေါ်ဘက် မြှောက်ပါ';
      case 'Lower your right arm':
        return 'ညာဘက်လက်ကို အောက်ချပါ';
      case 'Bend your left knee':
        return 'ဘယ်ဘက်ဒူးကို အနည်းငယ် ကွေးပါ';
      case 'Straighten your left leg':
        return 'ဘယ်ဘက်ဒူးကို ဆန့်တန်းပါ';
      case 'Bend your right knee':
        return 'ညာဘက်ဒူးကို အနည်းငယ် ကွေးပါ';
      case 'Straighten your right leg':
        return 'ညာဘက်ဒူးကို ဆန့်တန်းပါ';
      case 'Straighten your back':
        return 'ကျောကို တည့်တည့်ထားပါ';
      case 'Lean forward slightly':
        return 'ခန္ဓာကိုယ်ကို အနည်းငယ် ရှေ့ဘက် ညွတ်ပါ';
      case 'Match the reference pose':
        return 'ပုံတူကူးပါ';
      case 'Step back to show full body':
        return 'ခြေလှမ်းနောက်ဆုတ်ပါ';
      case 'No person detected':
        return 'လူတစ်ယောက် မတွေ့ပါ။ ကင်မရာရှေ့ ရပ်ပါ';
      case 'Not enough body visible':
        return 'ခန္ဓာကိုယ် အပြည့်အစုံ မပေါ်သေးပါ။ နောက်ဆုတ်ပါ';
      default:
        return english;
    }
  }

  void reset() {
    _lastSpokenMessage = '';
  }

  void dispose() {
    _cloudTts.stop();
    _initialized = false;
  }
}
