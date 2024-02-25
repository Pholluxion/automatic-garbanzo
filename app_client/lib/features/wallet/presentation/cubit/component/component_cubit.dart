import 'package:app_client/features/wallet/domain/domain.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'component_state.dart';

class ComponentCubit extends Cubit<ComponentState> {
  ComponentCubit(
    this._entryRepository,
    this._pocketService,
    this._budgetService,
    // this._userBudgetService,
  ) : super(ComponentInitial());

  final EntryService _entryRepository;
  final PocketService _pocketService;
  final BudgetService _budgetService;
  // final UserBudgetService _userBudgetService;

  /// Get all entries, pockets and user pockets and implements the composite pattern

  void getComponents() async {
    emit(ComponentLoading());
    try {
      final entries = await _entryRepository.getAll();
      final pockets = await _pocketService.getAll();
      final budgets = await _budgetService.getAll();
      // final userBudgets = await _userBudgetService.getAll();

      /// list entries to entry components
      final entryComponents = entries.map((entry) => EntryComponent(entry)).toList();

      /// list pockets to pocket components

      final pocketComponents = pockets.map((pocket) {
        final pocketEntries = entryComponents.where((entry) => entry.entry.pocketId == pocket.id).toList();
        return PocketComponent(pocket: pocket, componentes: pocketEntries);
      }).toList();

      /// list budgets to budget components

      final budgetComponents = budgets.map((budget) {
        final budgetPockets = pocketComponents.where((pocket) => pocket.pocket.idBudget == budget.id).toList();
        return BudgetComponent(budget: budget, componentes: budgetPockets);
      }).toList();

      /// list user budget to  budget components

      // final userBudgetComponents = userBudgets.map((userPocket) {
      //   final budgets = budgetComponents.where((budget) => budget.budget.id == userPocket.idBudget).toList();
      //   return UserBudgetComponent(userBudget: userPocket, componentes: budgets);
      // }).toList();

      emit(ComponentLoaded(budgetComponents));
    } catch (e) {
      emit(ComponentError(e.toString()));
    }
  }
}
