import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app_client/core/core.dart';
import 'package:app_client/features/wallet/data/data.dart';
import 'package:app_client/features/wallet/domain/domain.dart';

abstract class ServiceLocator {
  static final GetIt instance = GetIt.instance;

  static Future<void> initialize() async {
    instance.registerSingletonAsync<SupabaseClient>(
      () async => (await Supabase.initialize(url: Constants.supabaseUrl, anonKey: Constants.supabaseKey)).client,
    );

    await instance.isReady<SupabaseClient>();

    instance
      ..registerSingleton<EntryRepository>(EntryRepositoryImpl(instance.get<SupabaseClient>()))
      ..registerSingleton<PocketRepository>(PocketRepositoryImpl(instance.get<SupabaseClient>()))
      ..registerSingleton<UserPocketRepository>(UserPocketRepositoryImpl(instance.get<SupabaseClient>()))
      ..registerSingleton<EntryService>(EntryServiceImpl(instance.get<EntryRepository>()))
      ..registerSingleton<PocketService>(PocketServiceImpl(instance.get<PocketRepository>()))
      ..registerSingleton<UserPocketService>(UserPocketServiceImpl(instance.get<UserPocketRepository>()));
  }
}
