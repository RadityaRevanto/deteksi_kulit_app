class SkinConcern {
  final String uuid;
  final String name;
  final String mlLabel;
  final String description;
  final int defaultSeverityScore;
  final bool isActive;

  const SkinConcern({
    required this.uuid,
    required this.name,
    required this.mlLabel,
    required this.description,
    required this.defaultSeverityScore,
    required this.isActive,
  });
}
