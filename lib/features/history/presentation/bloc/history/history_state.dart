import '../../../domain/entities/history.dart';

sealed class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<History> histories;

  HistoryLoaded(this.histories);
}

class HistoryFailure extends HistoryState {
  final String message;

  HistoryFailure(this.message);
}
