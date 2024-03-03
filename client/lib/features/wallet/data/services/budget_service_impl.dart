import 'package:client/features/wallet/domain/domain.dart';

class BudgetServiceImpl implements BudgetService {

  BudgetServiceImpl(this._budgetRepository);
  final BudgetRepository _budgetRepository;

  @override
  Future<bool> create(Budget entity) async {
    return _budgetRepository.create(entity);
  }

  @override
  Future<bool> delete(int id) async {
    return _budgetRepository.delete(id);
  }

  @override
  Future<List<Budget>> getAll() async {
    return _budgetRepository.getAll();
  }

  @override
  Future<Budget> getById(int id) async {
    return _budgetRepository.getById(id);
  }

  @override
  Future<bool> update(Budget entity) async {
    return _budgetRepository.update(entity);
  }
}
