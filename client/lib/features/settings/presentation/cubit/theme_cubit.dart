import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  void changeTheme({FlexScheme? scheme, bool? isDark}) {
    emit(state.copyWith(scheme: scheme, isDark: isDark));
  }
}

class ThemeState extends Equatable {
  final bool isDark;
  final FlexScheme scheme;
  const ThemeState({
    this.scheme = FlexScheme.bahamaBlue,
    this.isDark = false,
  });

  @override
  List<Object?> get props => [scheme, isDark];

  ThemeState copyWith({
    FlexScheme? scheme,
    bool? isDark,
  }) {
    return ThemeState(
      scheme: scheme ?? this.scheme,
      isDark: isDark ?? this.isDark,
    );
  }
}
