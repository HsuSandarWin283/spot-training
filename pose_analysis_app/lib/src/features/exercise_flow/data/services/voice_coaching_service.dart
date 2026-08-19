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

  Future<void> speakDescription(String description, {required String languageCode}) async {
    if (!_enabled || description.trim().isEmpty || !_initialized) return;
    if (_cloudTts.isPlaying) {
      await _cloudTts.stop();
    }
    _lastSpokenMessage = '';
    final ttsLang = languageCode == 'my' ? 'my-MM' : 'en-US';
    debugPrint('VoiceCoaching: speaking description "$description"');
    await _cloudTts.speak(text: description, languageCode: ttsLang);
  }

  Future<void> speakFeedback(List<String> corrections, {String languageCode = 'my'}) async {
    if (!_enabled || corrections.isEmpty || !_initialized) return;

    final newMessage = corrections.first;
    if (newMessage == _lastSpokenMessage) return;

    _lastSpokenMessage = newMessage;

    final text = languageCode == 'my' ? _toMyanmar(newMessage) : newMessage;
    final ttsLang = languageCode == 'my' ? 'my-MM' : 'en-US';
    debugPrint('VoiceCoaching: speaking "$text"');
    await _cloudTts.speak(text: text, languageCode: ttsLang);
  }

  Future<void> speakSuccess({String languageCode = 'my'}) async {
    if (!_enabled || _cloudTts.isPlaying || !_initialized) return;
    _lastSpokenMessage = '';
    final text = languageCode == 'my' ? 'အလွန်ကောင်းပါသည်' : 'Excellent!';
    final ttsLang = languageCode == 'my' ? 'my-MM' : 'en-US';
    debugPrint('VoiceCoaching: speaking success');
    await _cloudTts.speak(text: text, languageCode: ttsLang);
  }

  Future<void> speakStepComplete(int stepNumber, {String languageCode = 'my'}) async {
    if (!_enabled || _cloudTts.isPlaying || !_initialized) return;
    _lastSpokenMessage = '';
    final text = languageCode == 'my' ? 'နောက်တစ်ဆင့်သို့ ဆက်သွားနိုင်ပါပြီ' : 'You can continue to the next step';
    final ttsLang = languageCode == 'my' ? 'my-MM' : 'en-US';
    debugPrint('VoiceCoaching: speaking step complete');
    await _cloudTts.speak(text: text, languageCode: ttsLang);
  }

  Future<void> speakExerciseComplete({String languageCode = 'my'}) async {
    if (!_enabled || _cloudTts.isPlaying || !_initialized) return;
    _lastSpokenMessage = '';
    final text = languageCode == 'my' ? 'လေ့ကျင့်ခန်း ပြီးဆုံးပါပြီ။ ကျေးဇူးတင်ပါသည်' : 'Exercise complete. Thank you.';
    final ttsLang = languageCode == 'my' ? 'my-MM' : 'en-US';
    debugPrint('VoiceCoaching: speaking exercise complete');
    await _cloudTts.speak(text: text, languageCode: ttsLang);
  }

  String _toMyanmar(String english) {
    switch (english) {
      case 'Raise your left arm slightly':
        return 'ဘယ်လက် အပေါ် နည်းနည်းမြှောက်ပါ';
      case 'Lower your left arm slightly':
        return 'ဘယ်လက် အောက် နည်းနည်းချပါ';
      case 'Raise your right arm slightly':
        return 'ညာလက် အပေါ် နည်းနည်းမြှောက်ပါ';
      case 'Lower your right arm slightly':
        return 'ညာလက် အောက် နည်းနည်းချပါ';
      case 'Bend your left knee slightly more':
        return 'ဘယ်ဒူး နည်းနည်းပိုကွေးပါ';
      case 'Straighten your left leg slightly':
        return 'ဘယ်ဘက်ခြေထောက်ကို အနည်းငယ်ဖြောင့်ထားပါ';
      case 'Bend your right knee slightly more':
        return 'ညာဒူး နည်းနည်းပိုကွေးပါ';
      case 'Straighten your right leg slightly':
        return 'ညာဘက်ခြေထောက်ကို အနည်းငယ်ဖြောင့်ထားပါ';
      case 'Lean backward slightly':
        return 'ကိုယ်ခန္ဓာ နောက် နည်းနည်းဆုတ်ပါ';
      case 'Lean forward slightly':
        return 'ကိုယ်ခန္ဓာ ရှေ့ နည်းနည်းစောင်းပါ';
      case 'Move your left foot slightly left':
        return 'ဘယ်ခြေ ဘယ် နည်းနည်းရွှေ့ပါ';
      case 'Move your left foot slightly right':
        return 'ဘယ်ခြေ ညာ နည်းနည်းရွှေ့ပါ';
      case 'Move your right foot slightly left':
        return 'ညာခြေ ဘယ် နည်းနည်းရွှေ့ပါ';
      case 'Move your right foot slightly right':
        return 'ညာခြေ ညာ နည်းနည်းရွှေ့ပါ';
      case 'Relax your shoulders slightly':
        return 'ပခုံး နည်းနည်းဖြေလျှော့ပါ';
      case 'Match the reference pose':
        return 'ပုံတူကူးပါ';
      case 'Step back to show full body':
        return 'ခြေလှမ်းနောက်ဆုတ်ပါ';
      case 'Full body not shown':
        return 'ကိုယ်ခန္ဓာအပြည့်မပေါ်ပါ';
      case 'No person found':
        return 'လူမတွေ့ပါ';
      case 'No person detected':
        return 'လူတစ်ယောက် မတွေ့ပါ။ ကင်မရာရှေ့ ရပ်ပါ';
      case 'Not enough body visible':
        return 'ခန္ဓာကိုယ် အပြည့်အစုံ မပေါ်သေးပါ။ နောက်ဆုတ်ပါ';
      case 'Successful, the next step will be displayed in 5 seconds.':
        return 'အောင်မြင်သွားပါပြီ နောက်တဆင့်ကို ၅စက္ကန့်နေရင်ဖော်ပြပေးပါမည်';
      case 'Successfully completed, press the button to proceed to the next step.':
        return 'အောင်မြင်သွားပါပြီ နောက်တဆင့်တက်ဖိုအတွက် ခလုတ်ကိုနှိပ်ပါ';
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
