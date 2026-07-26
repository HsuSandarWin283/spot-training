enum FeedbackType {
  landmark,
  angle,
  general,
  success,
}

class CoachingFeedback {
  final String messageMyanmar;
  final String messageEnglish;
  final FeedbackType type;
  final String landmarkName;
  final double angleDifference;

  CoachingFeedback({
    required this.messageMyanmar,
    required this.messageEnglish,
    required this.type,
    this.landmarkName = '',
    this.angleDifference = 0,
  });
}
