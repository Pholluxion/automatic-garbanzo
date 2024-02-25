import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_client/core/core.dart';
import 'package:app_client/features/wallet/domain/domain.dart';
import 'package:app_client/features/wallet/presentation/cubit/cubit.dart';
import 'package:app_client/features/wallet/presentation/presentation.dart';
import 'package:app_client/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EntryCubit(
            ServiceLocator.instance.get<EntryService>(),
          )..getEntries(),
        ),
        BlocProvider(
          create: (context) => PocketCubit(
            ServiceLocator.instance.get<PocketService>(),
          )..getPockets(),
        ),
        BlocProvider(
          create: (context) => UserPocketCubit(
            ServiceLocator.instance.get<UserPocketService>(),
          )..getUserPockets(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: '/pocket',
        routes: {
          '/pocket': (context) => const PocketPage(),
          '/pocket_entries': (context) => const EntryPage(),
        },
      ),
    );
  }
}
