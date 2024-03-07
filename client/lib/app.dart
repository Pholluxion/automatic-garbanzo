import 'package:client/features/auth/presentation/presentation.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/core/core.dart';
import 'package:client/features/wallet/domain/domain.dart';
import 'package:client/features/wallet/presentation/presentation.dart';
import 'features/settings/presentation/cubit/theme_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ComponentCubit(
            ServiceLocator.instance.get<EntryService>(),
            ServiceLocator.instance.get<PocketService>(),
            ServiceLocator.instance.get<BudgetService>(),
            ServiceLocator.instance.get<UserBudgetService>(),
          )..getComponents(),
        ),
        BlocProvider(create: (context) => BottomBarCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: const MateApp(),
    );
  }
}

class MateApp extends StatelessWidget {
  const MateApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
          darkTheme: FlexThemeData.dark(scheme: state.scheme).getData,
          theme: FlexThemeData.light(scheme: state.scheme).getData,
          home: const LoginPage(),
        );
      },
    );
  }
}
