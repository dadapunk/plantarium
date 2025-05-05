class PlantingRecommendation {
  final String id;
  final String plantName;
  final String plantingTimeRange;
  final String sunRequirement;
  final String waterRequirement;
  final bool isIdealTime;
  final bool isPossible;

  PlantingRecommendation({
    required this.id,
    required this.plantName,
    required this.plantingTimeRange,
    required this.sunRequirement,
    required this.waterRequirement,
    this.isIdealTime = false,
    this.isPossible = true,
  });
}
