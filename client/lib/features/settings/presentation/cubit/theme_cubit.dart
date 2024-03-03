import 'package:equatable/equatable.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  void changeTheme({FlexScheme? scheme, bool? isDark}) {
    emit(state.copyWith(scheme: scheme, isDark: isDark));
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    return ThemeState(
      scheme: FlexScheme.values[json['scheme'] as int],
      isDark: json['isDark'] as bool,
    );
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {
      'scheme': state.scheme.index,
      'isDark': state.isDark,
    };
  }
}

class ThemeState extends Equatable {
  const ThemeState({
    this.scheme = FlexScheme.bahamaBlue,
    this.isDark = false,
  });
  final bool isDark;
  final FlexScheme scheme;

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
