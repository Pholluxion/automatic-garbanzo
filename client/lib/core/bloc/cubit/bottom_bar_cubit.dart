import 'package:bloc/bloc.dart';

class BottomBarCubit extends Cubit<int> {
  BottomBarCubit() : super(0);

  void changeIndex(int index) {
    emit(index);
  }
}
