import 'package:app_client/features/wallet/domain/domain.dart';

class EntryServiceImpl implements EntryService {
  final EntryRepository _entryRepository;

  EntryServiceImpl(this._entryRepository);

  @override
  Future<bool> create(Entry entity) async {
    return await _entryRepository.create(entity);
  }

  @override
  Future<bool> delete(int id) async {
    return await _entryRepository.delete(id);
  }

  @override
  Future<List<Entry>> getAll() async {
    return await _entryRepository.getAll();
  }

  @override
  Future<Entry> getById(int id) async {
    return await _entryRepository.getById(id);
  }

  @override
  Future<Entry> update(Entry entity) async {
    return await _entryRepository.update(entity);
  }
}