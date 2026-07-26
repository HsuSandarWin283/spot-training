class ExerciseStep {
  final int stepNumber;
  final String title;
  final String description;
  final String imageUrl;
  final Map<String, List<double>> poseLandmarks;
  final Map<String, double> poseAngles;
  final bool autoNext;

  ExerciseStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.poseLandmarks = const {},
    this.poseAngles = const {},
    this.autoNext = true,
  });

  factory ExerciseStep.fromMap(Map<String, dynamic> map) {
    final rawLandmarks = <String, List<double>>{};
    final lmData = Map<String, dynamic>.from(map['poseLandmarks'] ?? {});
    for (final entry in lmData.entries) {
      if (entry.value is List) {
        rawLandmarks[entry.key] =
            (entry.value as List).map((e) => (e as num).toDouble()).toList();
      }
    }

    final rawAngles = <String, double>{};
    final angleData = Map<String, dynamic>.from(map['poseAngles'] ?? {});
    for (final entry in angleData.entries) {
      if (entry.value is num) {
        rawAngles[entry.key] = (entry.value as num).toDouble();
      }
    }

    return ExerciseStep(
      stepNumber: map['stepNumber'] ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      poseLandmarks: rawLandmarks,
      poseAngles: rawAngles,
      autoNext: map['autoNext'] ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
    'stepNumber': stepNumber,
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
    'poseLandmarks': poseLandmarks,
    'poseAngles': poseAngles,
    'autoNext': autoNext,
  };
}
