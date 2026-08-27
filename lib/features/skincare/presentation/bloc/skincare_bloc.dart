import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/skincare_remote_data_source.dart';
import 'skincare_event.dart';
import 'skincare_state.dart';

class SkincareBloc extends Bloc<SkincareEvent, SkincareState> {
  final SkincareRemoteDataSource remoteDataSource;

  SkincareBloc({required this.remoteDataSource}) : super(const SkincareState()) {
    on<FetchSkincareCatalogEvent>(_onFetchCatalog);
    on<FetchSkinRecommendationsEvent>(_onFetchRecommendations);
  }

  Future<void> _onFetchCatalog(
    FetchSkincareCatalogEvent event,
    Emitter<SkincareState> emit,
  ) async {
    emit(state.copyWith(status: SkincareStatus.loading));
    try {
      final concerns = await remoteDataSource.getSkinConcerns();
      final skinTypes = await remoteDataSource.getSkinTypes();
      final products = await remoteDataSource.getSkincareProducts(
        concernUuid: event.concernUuid,
        skinTypeUuid: event.skinTypeUuid,
        gender: event.gender,
      );

      var filtered = products;
      if (event.searchQuery != null && event.searchQuery!.isNotEmpty) {
        final query = event.searchQuery!.toLowerCase();
        filtered = products
            .where((p) =>
                p.name.toLowerCase().contains(query) ||
                p.category.toLowerCase().contains(query) ||
                p.keyIngredients.toLowerCase().contains(query))
            .toList();
      }

      emit(state.copyWith(
        status: SkincareStatus.success,
        products: filtered,
        concerns: concerns,
        skinTypes: skinTypes,
        selectedConcernUuid: event.concernUuid,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SkincareStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onFetchRecommendations(
    FetchSkinRecommendationsEvent event,
    Emitter<SkincareState> emit,
  ) async {
    emit(state.copyWith(status: SkincareStatus.loading));
    try {
      final recs = await remoteDataSource.getSkinRecommendations(
        mlLabel: event.mlLabel,
        concernId: event.concernId,
      );

      emit(state.copyWith(
        status: SkincareStatus.success,
        recommendations: recs,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SkincareStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
