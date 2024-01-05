import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';

import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app_client/core/core.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  await Supabase.initialize(url: Constants.supabaseUrl, anonKey: Constants.supabaseKey);
  ServiceLocator.initialize();
  await ServiceLocator.instance.get<SupabaseClient>().auth.signOut();
  await ServiceLocator.instance
      .get<SupabaseClient>()
      .auth
      .signInWithPassword(password: '12345678', email: 'test@test.com');

  runApp(await builder());
}
