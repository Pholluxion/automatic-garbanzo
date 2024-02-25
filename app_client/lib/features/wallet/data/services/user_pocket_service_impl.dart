import 'package:app_client/features/wallet/domain/domain.dart';

class UserPocketServiceImpl implements UserPocketService {
  final UserPocketRepository _userPocketRepository;

  UserPocketServiceImpl(this._userPocketRepository);

  @override
  Future<bool> create(UserPocket entity) async {
    return await _userPocketRepository.create(entity);
  }

  @override
  Future<bool> delete(int id) async {
    return await _userPocketRepository.delete(id);
  }

  @override
  Future<List<UserPocket>> getAll() async {
    return await _userPocketRepository.getAll();
  }

  @override
  Future<UserPocket> getById(int id) async {
    return await _userPocketRepository.getById(id);
  }

  @override
  Future<UserPocket> update(UserPocket entity) async {
    return await _userPocketRepository.update(entity);
  }
}
