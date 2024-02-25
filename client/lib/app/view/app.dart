import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/core/core.dart';
import 'package:client/features/wallet/domain/domain.dart';
import 'package:client/features/wallet/presentation/cubit/cubit.dart';
import 'package:client/features/wallet/presentation/view/view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComponentCubit(
        ServiceLocator.instance.get<EntryService>(),
        ServiceLocator.instance.get<PocketService>(),
        ServiceLocator.instance.get<BudgetService>(),
        // ServiceLocator.instance.get<UserBudgetService>(),
      )..getComponents(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        home: const BudgetPage(),
      ),
    );
  }
}
