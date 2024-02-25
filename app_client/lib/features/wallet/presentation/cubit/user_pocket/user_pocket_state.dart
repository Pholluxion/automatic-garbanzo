part of 'user_pocket_cubit.dart';

sealed class UserPocketState extends Equatable {
  const UserPocketState();

  @override
  List<Object> get props => [];
}

final class UserPocketInitial extends UserPocketState {}

final class UserPocketLoading extends UserPocketState {}

final class UserPocketLoaded extends UserPocketState {
  final List<UserBudget> userPockets;

  const UserPocketLoaded(this.userPockets);

  @override
  List<Object> get props => [userPockets];
}

final class UserPocketError extends UserPocketState {
  final String message;

  const UserPocketError(this.message);

  @override
  List<Object> get props => [message];
}
