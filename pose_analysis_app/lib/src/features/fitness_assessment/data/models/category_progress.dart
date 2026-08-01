class CategoryProgress {
  final String categoryId;
  final String categoryName;
  final String? categoryImageUrl;
  final int totalSessions;
  final double averageAccuracy;
  final double improvementPercentage;
  final int totalCaloriesBurned;
  final DateTime? lastSessionAt;

  const CategoryProgress({
    required this.categoryId,
    required this.categoryName,
    this.categoryImageUrl,
    required this.totalSessions,
    required this.averageAccuracy,
    required this.improvementPercentage,
    required this.totalCaloriesBurned,
    this.lastSessionAt,
  });
}
