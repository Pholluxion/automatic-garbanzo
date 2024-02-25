import 'package:app_client/features/wallet/domain/domain.dart';
import 'package:bloc/bloc.dart';

part 'entry_state.dart';

class EntryCubit extends Cubit<EntryState> {
  EntryCubit(
    this._walletRepository,
  ) : super(EntryInitial());

  final EntryService _walletRepository;

  Future<void> getEntries() async {
    emit(EntryLoading());
    try {
      final entries = await _walletRepository.getAll();
      emit(EntryLoaded(entries));
    } catch (e) {
      emit(EntryError(e.toString()));
    }
  }

  Future<void> createEntry(Entry entry) async {
    emit(EntryLoading());
    try {
      await _walletRepository.create(entry);
      await getEntries();
    } catch (e) {
      emit(EntryError(e.toString()));
    }
  }

  Future<void> deleteEntry(int id) async {
    emit(EntryLoading());
    try {
      await _walletRepository.delete(id);
      await getEntries();
    } catch (e) {
      emit(EntryError(e.toString()));
    }
  }
}
