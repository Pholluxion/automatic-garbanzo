import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import 'package:client/features/wallet/domain/domain.dart';
import 'package:client/features/wallet/presentation/components/components.dart';

part 'component_state.dart';

class ComponentCubit extends Cubit<ComponentState> {
  ComponentCubit(
    this._entryRepository,
    this._pocketService,
    this._budgetService,
    this._userBudgetService,
  ) : super(ComponentInitial());

  final EntryService _entryRepository;
  final PocketService _pocketService;
  final BudgetService _budgetService;
  final UserBudgetService _userBudgetService;

  /// Get all entries, pockets and user pockets and implements the composite pattern

  void getComponents({bool showsimmer = true}) async {
    if (showsimmer) emit(ComponentLoading());

    try {
      final entries = await _entryRepository.getAll();
      final pockets = await _pocketService.getAll();
      final budgets = await _budgetService.getAll();

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

      emit(ComponentLoaded(budgetComponents));
    } catch (e) {
      emit(ComponentError(e.toString()));
    }
  }

  void createEntry(Entry entry) async {
    try {
      await _entryRepository.create(entry);
      getComponents();
    } catch (e) {
      emit(ComponentError(e.toString()));
    }
  }

  void createPocket(Pocket pocket) async {
    try {
      await _pocketService.create(pocket);
      getComponents();
    } catch (e) {
      emit(ComponentError(e.toString()));
    }
  }

  void createBudget(Budget budget) async {
    try {
      await _budgetService.create(budget);
      getComponents();
    } catch (e) {
      emit(ComponentError(e.toString()));
    }
  }

  void createBudgetUser(int id) async {
    final UserBudget userBudget = UserBudget(idBudget: id);
    try {
      await _userBudgetService.create(userBudget);
      getComponents();
    } catch (e) {
      emit(ComponentError(e.toString()));
    }
  }

  List<Component> getAllEntries(int pocketId) {
    List<EntryComponent> entries = [];

    if (state is ComponentLoaded) {
      final componentLoaded = state as ComponentLoaded;

      for (var element in componentLoaded.components) {
        final pocket = element.components as List<PocketComponent>;
        for (var pocketComponent in pocket) {
          if (pocketComponent.pocket.id == pocketId) {
            entries = pocketComponent.components as List<EntryComponent>;
          }
        }
      }
    }

    return entries;
  }

  List<Component> getAllPockets(int budgetId) {
    List<PocketComponent> pockets = [];

    if (state is ComponentLoaded) {
      final componentLoaded = state as ComponentLoaded;
      final budgetComponent = componentLoaded.components.firstWhere(
        (element) => element is BudgetComponent && element.budget.id == budgetId,
      );

      final budget = budgetComponent as BudgetComponent;

      pockets = budget.components.map((e) => (e as PocketComponent)).toList();
    }

    return pockets;
  }

  void deleteEntry(int id) async {
    try {
      unawaited(_entryRepository.delete(id));
      getComponents(showsimmer: false);
    } catch (e) {
      emit(ComponentError(e.toString()));
    }
  }

  void deletePocket(int id) async {
    try {
      unawaited(_pocketService.delete(id));
      getComponents(showsimmer: false);
    } catch (e) {
      emit(ComponentError(e.toString()));
    }
  }

  void deleteBudget(int id) async {
    try {
      unawaited(_budgetService.delete(id));
      getComponents(showsimmer: false);
    } catch (e) {
      emit(ComponentError(e.toString()));
    }
  }

  void updateEntry(Entry entry) async {
    try {
      unawaited(_entryRepository.update(entry));
      getComponents(showsimmer: false);
    } catch (e) {
      emit(ComponentError(e.toString()));
    }
  }

  void updatePocket(Pocket pocket) async {
    try {
      unawaited(_pocketService.update(pocket));
      getComponents(showsimmer: false);
    } catch (e) {
      emit(ComponentError(e.toString()));
    }
  }

  void updateBudget(Budget budget) async {
    try {
      unawaited(_budgetService.update(budget));
      getComponents(showsimmer: false);
    } catch (e) {
      emit(ComponentError(e.toString()));
    }
  }

  String getFormatTotalEntry(PocketComponent component) {
    final total = getTotal(component);
    return getFormatTotal(total);
  }

  double getTotal(PocketComponent component) {
    double total = component.pocket.amount;
    final entries = getAllEntries(component.pocket.id) as List<EntryComponent>;
    for (var entry in entries) {
      if (entry.entry.type.name == 'expense') {
        total -= entry.entry.amount;
      } else {
        total += entry.entry.amount;
      }
    }

    return total;
  }

  ///get total of all pockets
  String getFormatTotalBudget() {
    if (state is ComponentLoaded && (state as ComponentLoaded).components.isEmpty) {
      return '0';
    }

    final total = state is ComponentLoaded
        ? (state as ComponentLoaded)
            .components
            .map((e) => getTotalBudget(e))
            .reduce((value, element) => value + element)
        : 0;
    return getFormatTotal(double.parse(total.toString()));
  }

  double getTotalBudget(Component component) {
    double total = 0;
    if (component is! BudgetComponent) return total;

    final pockets = getAllPockets(component.budget.id) as List<PocketComponent>;
    for (var pocket in pockets) {
      total += getTotal(pocket);
    }

    return total;
  }

  String getFormatTotal(double total) {
    final simpleCurrency = NumberFormat.decimalPatternDigits(decimalDigits: 0);
    return simpleCurrency.format(total).replaceAll(',', '.');
  }
}
