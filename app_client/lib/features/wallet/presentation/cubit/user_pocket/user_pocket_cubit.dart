import 'package:app_client/features/wallet/domain/domain.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_pocket_state.dart';

class UserPocketCubit extends Cubit<UserPocketState> {
  UserPocketCubit(this._userPocketService) : super(UserPocketInitial());

  final UserPocketService _userPocketService;

  void getUserPockets() async {
    emit(UserPocketLoading());
    try {
      final userPockets = await _userPocketService.getAll();
      emit(UserPocketLoaded(userPockets));
    } catch (e) {
      emit(UserPocketError(e.toString()));
    }
  }
}
