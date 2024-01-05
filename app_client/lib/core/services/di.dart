import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ServiceLocator {
  static final GetIt instance = GetIt.instance;
  static void initialize() {
    instance.registerSingleton<SupabaseClient>(Supabase.instance.client);
  }
}
