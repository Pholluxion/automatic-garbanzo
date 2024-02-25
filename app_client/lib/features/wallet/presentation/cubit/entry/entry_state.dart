part of 'entry_cubit.dart';

sealed class EntryState {}

final class EntryInitial extends EntryState {}

final class EntryLoading extends EntryState {}

final class EntryLoaded extends EntryState {
  final List<Entry> entries;

  EntryLoaded(this.entries);
}

final class EntryError extends EntryState {
  final String message;

  EntryError(this.message);
}
