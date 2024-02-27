import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'package:client/core/core.dart';
import 'package:client/features/wallet/domain/domain.dart';
import 'package:client/features/wallet/presentation/cubit/cubit.dart';
import 'package:client/features/wallet/presentation/pages/view.dart';

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
            // ServiceLocator.instance.get<UserBudgetService>(),
          )..getComponents(),
        ),
        BlocProvider(
          create: (context) => BottomBarCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: FlexThemeData.light(scheme: FlexScheme.blueWhale),
        home: const BudgetPage(),
      ),
    );
  }
}
