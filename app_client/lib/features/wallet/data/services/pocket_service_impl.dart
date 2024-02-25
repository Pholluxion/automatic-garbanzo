import 'package:app_client/features/wallet/domain/domain.dart';

class PocketServiceImpl implements PocketService {
  final PocketRepository _pocketRepository;

  PocketServiceImpl(this._pocketRepository);

  @override
  Future<bool> create(Pocket entity) async {
    return await _pocketRepository.create(entity);
  }

  @override
  Future<bool> delete(int id) async {
    return await _pocketRepository.delete(id);
  }

  @override
  Future<List<Pocket>> getAll() async {
    return await _pocketRepository.getAll();
  }

  @override
  Future<Pocket> getById(int id) async {
    return await _pocketRepository.getById(id);
  }

  @override
  Future<Pocket> update(Pocket entity) async {
    return await _pocketRepository.update(entity);
  }
}
