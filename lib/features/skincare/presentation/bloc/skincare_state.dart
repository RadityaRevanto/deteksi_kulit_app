import '../../domain/entities/skin_concern.dart';
import '../../domain/entities/skin_recommendation.dart';
import '../../domain/entities/skin_type.dart';
import '../../domain/entities/skincare_product.dart';

enum SkincareStatus { initial, loading, success, failure }

class SkincareState {
  final SkincareStatus status;
  final List<SkincareProduct> products;
  final List<SkinRecommendation> recommendations;
  final List<SkinConcern> concerns;
  final List<SkinType> skinTypes;
  final String? selectedCategory;
  final String? selectedConcernUuid;
  final String? errorMessage;

  const SkincareState({
    this.status = SkincareStatus.initial,
    this.products = const [],
    this.recommendations = const [],
    this.concerns = const [],
    this.skinTypes = const [],
    this.selectedCategory,
    this.selectedConcernUuid,
    this.errorMessage,
  });

  SkincareState copyWith({
    SkincareStatus? status,
    List<SkincareProduct>? products,
    List<SkinRecommendation>? recommendations,
    List<SkinConcern>? concerns,
    List<SkinType>? skinTypes,
    String? selectedCategory,
    String? selectedConcernUuid,
    String? errorMessage,
  }) {
    return SkincareState(
      status: status ?? this.status,
      products: products ?? this.products,
      recommendations: recommendations ?? this.recommendations,
      concerns: concerns ?? this.concerns,
      skinTypes: skinTypes ?? this.skinTypes,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedConcernUuid: selectedConcernUuid ?? this.selectedConcernUuid,
      errorMessage: errorMessage,
    );
  }
}
