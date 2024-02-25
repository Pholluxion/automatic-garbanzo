import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';

import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:client/core/core.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  await ServiceLocator.initialize();

  /// auth with test user
  ///
  await (ServiceLocator.instance.get<SupabaseClient>().auth.signInWithPassword(
        email: Constants.testEmail,
        password: Constants.testPassword,
      ));

  runApp(await builder());
}
