import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_client/core/core.dart';
import 'package:app_client/features/wallet/domain/domain.dart';
import 'package:app_client/features/wallet/presentation/cubit/cubit.dart';
import 'package:app_client/features/wallet/presentation/view/view.dart';
import 'package:app_client/l10n/l10n.dart';

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
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const BudgetPage(),
      ),
    );
  }
}
