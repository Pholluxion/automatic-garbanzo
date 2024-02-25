import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:app_client/features/wallet/domain/domain.dart';

part 'pocket_state.dart';

class PocketCubit extends Cubit<PocketState> {
  PocketCubit(this._pocketService) : super(PocketInitial());

  final PocketService _pocketService;

  Future<void> getPockets() async {
    try {
      emit(PocketLoading());
      final pockets = await _pocketService.getAll();
      emit(PocketLoaded(pockets));
    } catch (e) {
      emit(PocketError(e.toString()));
    }
  }

  Future<void> createPocket(Pocket pocket) async {
    try {
      emit(PocketLoading());
      final createdPocket = await _pocketService.create(pocket);
      if (createdPocket) {
        await getPockets();
      } else {
        emit(const PocketError('Error creating pocket'));
      }
    } catch (e) {
      emit(PocketError(e.toString()));
    }
  }
}
