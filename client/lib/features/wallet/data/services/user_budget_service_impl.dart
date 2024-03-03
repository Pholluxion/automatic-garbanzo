import 'package:client/features/wallet/domain/domain.dart';

class UserBudgetServiceImpl implements UserBudgetService {

  UserBudgetServiceImpl(this._userBudgetRepository);
  final UserBudgetRepository _userBudgetRepository;

  @override
  Future<bool> create(UserBudget entity) async {
    return await _userBudgetRepository.create(entity);
  }

  @override
  Future<bool> delete(int id) async {
    return await _userBudgetRepository.delete(id);
  }

  @override
  Future<List<UserBudget>> getAll() async {
    return await _userBudgetRepository.getAll();
  }

  @override
  Future<UserBudget> getById(int id) async {
    return await _userBudgetRepository.getById(id);
  }

  @override
  Future<bool> update(UserBudget entity) async {
    return await _userBudgetRepository.update(entity);
  }
}
