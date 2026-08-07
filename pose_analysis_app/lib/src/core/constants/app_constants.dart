class AppConstants {
  static const String appName = 'AI Sports Training';
  static const String appVersion = '1.0.0';
  static const String defaultLanguage = 'en';
  static const int maxRetryAttempts = 3;
  static const Duration cacheTimeout = Duration(hours: 24);

  static const List<SportData> sports = [
    SportData(
      id: 'football',
      name: 'Football',
      icon: '⚽',
      color: 0xFF4CAF50,
      description: 'Master the beautiful game with AI-powered training.',
    ),
    SportData(
      id: 'basketball',
      name: 'Basketball',
      icon: '🏀',
      color: 0xFFFF9800,
      description: 'Elevate your court skills with intelligent coaching.',
    ),
    SportData(
      id: 'volleyball',
      name: 'Volleyball',
      icon: '🏐',
      color: 0xFF2196F3,
      description: 'Perfect your serve and spike technique.',
    ),
    SportData(
      id: 'badminton',
      name: 'Badminton',
      icon: '🏸',
      color: 0xFFE91E63,
      description: 'Sharpen your reflexes and footwork.',
    ),
  ];

  static const List<String> supportedSports = [
    'football',
    'basketball',
    'volleyball',
    'badminton',
  ];

  static const List<TrainingDay> weeklyPlan = [
    TrainingDay(
      day: 'Monday',
      title: 'Warm Up',
      subtitle: '15 minutes',
      icon: '🔥',
      color: 0xFFFF6B6B,
    ),
    TrainingDay(
      day: 'Tuesday',
      title: 'Cardio Exercise',
      subtitle: '30 minutes',
      icon: '❤️',
      color: 0xFFFF9800,
    ),
    TrainingDay(
      day: 'Wednesday',
      title: 'Sport Drills',
      subtitle: '45 minutes',
      icon: '⚡',
      color: 0xFF6C63FF,
    ),
    TrainingDay(
      day: 'Thursday',
      title: 'Strength Training',
      subtitle: '40 minutes',
      icon: '💪',
      color: 0xFF00D4AA,
    ),
    TrainingDay(
      day: 'Friday',
      title: 'Cool Down & Stretching',
      subtitle: '20 minutes',
      icon: '🧘',
      color: 0xFF9C27B0,
    ),
    TrainingDay(
      day: 'Saturday',
      title: 'Game Practice',
      subtitle: '60 minutes',
      icon: '🏆',
      color: 0xFFE91E63,
    ),
    TrainingDay(
      day: 'Sunday',
      title: 'Rest Day',
      subtitle: 'Recovery',
      icon: '😴',
      color: 0xFF607D8B,
    ),
  ];

  static const List<InjuryPreventionTip> injuryTips = [
    InjuryPreventionTip(
      title: 'Warm Up Exercises',
      description: 'Start with light jogging and dynamic stretches to prepare your muscles.',
      icon: '🏃',
      duration: '10 min',
    ),
    InjuryPreventionTip(
      title: 'Neck Stretch',
      description: 'Gently roll your neck in circles, both clockwise and counterclockwise.',
      icon: '🔄',
      duration: '2 min',
    ),
    InjuryPreventionTip(
      title: 'Arm Stretch',
      description: 'Extend your arm across your chest and hold with the opposite hand.',
      icon: '🤸',
      duration: '3 min',
    ),
    InjuryPreventionTip(
      title: 'Leg Stretch',
      description: 'Stand on one leg and pull your ankle toward your glutes.',
      icon: '🦵',
      duration: '3 min',
    ),
    InjuryPreventionTip(
      title: 'Jumping Jacks',
      description: 'Perform 20 jumping jacks to increase heart rate and warm up.',
      icon: '⭐',
      duration: '2 min',
    ),
  ];
}

class SportData {
  final String id;
  final String name;
  final String nameMm;
  final String icon;
  final int color;
  final String description;
  final String descriptionMm;

  const SportData({
    required this.id,
    required this.name,
    this.nameMm = '',
    required this.icon,
    required this.color,
    required this.description,
    this.descriptionMm = '',
  });

  String localizedName(String languageCode) {
    if (languageCode == 'my' && nameMm.isNotEmpty) return nameMm;
    return name;
  }

  String localizedDescription(String languageCode) {
    if (languageCode == 'my' && descriptionMm.isNotEmpty) return descriptionMm;
    return description;
  }
}

class TrainingDay {
  final String day;
  final String title;
  final String subtitle;
  final String icon;
  final int color;

  const TrainingDay({
    required this.day,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class InjuryPreventionTip {
  final String title;
  final String description;
  final String icon;
  final String duration;

  const InjuryPreventionTip({
    required this.title,
    required this.description,
    required this.icon,
    required this.duration,
  });
}
