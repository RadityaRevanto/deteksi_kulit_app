import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_history.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistory getHistory;

  HistoryBloc(this.getHistory) : super(HistoryInitial()) {
    on<HistoryRequested>(_onHistoryRequested);
    on<HistoryRefreshed>(_onHistoryRequested);
  }

  Future<void> _onHistoryRequested(
    HistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());

    try {
      final histories = await getHistory();
      emit(HistoryLoaded(histories));
    } catch (e) {
      emit(HistoryFailure(e.toString()));
    }
  }
}
