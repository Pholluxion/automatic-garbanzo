import 'package:client/features/wallet/domain/domain.dart';

class PocketServiceImpl implements PocketService {

  PocketServiceImpl(this._pocketRepository);
  final PocketRepository _pocketRepository;

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
  Future<bool> update(Pocket entity) async {
    return await _pocketRepository.update(entity);
  }

  @override
  Future<List<Pocket>> getAllById(int params) async {
    return _pocketRepository.getAllById(params);
  }
}
