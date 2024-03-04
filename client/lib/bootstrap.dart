import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'package:client/core/core.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = const AppBlocObserver();
  await EasyLocalization.ensureInitialized();
  await ServiceLocator.initialize();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  // /// auth with test user
  // await ServiceLocator.instance.get<SupabaseClient>().auth.signInWithPassword(
  //       email: Constants.testEmail,
  //       password: Constants.testPassword,
  //     );

  runApp(await builder());
}
