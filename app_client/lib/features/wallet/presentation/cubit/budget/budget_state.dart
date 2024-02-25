part of 'budget_cubit.dart';

sealed class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object> get props => [];
}

final class BudgetInitial extends BudgetState {}

final class BudgetLoading extends BudgetState {}

final class BudgetCreated extends BudgetState {
  final Budget budget;

  const BudgetCreated(this.budget);

  @override
  List<Object> get props => [budget];
}

final class BudgetError extends BudgetState {
  final String message;

  const BudgetError(this.message);

  @override
  List<Object> get props => [message];
}
