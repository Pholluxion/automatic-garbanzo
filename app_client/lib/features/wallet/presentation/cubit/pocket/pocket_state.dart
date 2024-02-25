part of 'pocket_cubit.dart';

sealed class PocketState extends Equatable {
  const PocketState();

  @override
  List<Object> get props => [];
}

final class PocketInitial extends PocketState {}

final class PocketLoading extends PocketState {}

final class PocketLoaded extends PocketState {
  final List<Pocket> pockets;

  const PocketLoaded(this.pockets);

  @override
  List<Object> get props => [pockets];
}

final class PocketError extends PocketState {
  final String message;

  const PocketError(this.message);

  @override
  List<Object> get props => [message];
}
