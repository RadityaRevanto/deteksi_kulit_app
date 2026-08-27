abstract class SkincareEvent {
  const SkincareEvent();
}

class FetchSkincareCatalogEvent extends SkincareEvent {
  final String? concernUuid;
  final String? skinTypeUuid;
  final String? gender;
  final String? searchQuery;

  const FetchSkincareCatalogEvent({
    this.concernUuid,
    this.skinTypeUuid,
    this.gender,
    this.searchQuery,
  });
}

class FetchSkinRecommendationsEvent extends SkincareEvent {
  final String? mlLabel;
  final String? concernId;

  const FetchSkinRecommendationsEvent({
    this.mlLabel,
    this.concernId,
  });
}
