import 'package:app_client/features/wallet/domain/domain.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  BudgetCubit(this._budgetService) : super(BudgetInitial());

  final BudgetService _budgetService;

  /// create a new budget
  void createBudget(Budget budget) async {
    emit(BudgetLoading());
    try {
      await _budgetService.create(budget);
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }
}
