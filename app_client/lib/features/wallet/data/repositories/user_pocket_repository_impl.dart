import 'package:app_client/features/wallet/data/data.dart';
import 'package:app_client/features/wallet/domain/domain.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserPocketRepositoryImpl extends UserPocketRepository {
  final SupabaseClient _supabaseClient;

  UserPocketRepositoryImpl(this._supabaseClient);

  @override
  Future<bool> create(UserPocket entity) async {
    try {
      final response = await _supabaseClient
          .from('user_pocket')
          .upsert(
            entity.toJson(),
          )
          .select('id');
      return response.isNotEmpty;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> delete(int id) async {
    try {
      await _supabaseClient.from('user_pocket').delete().eq(
            'id',
            id,
          );

      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<UserPocket>> getAll() async {
    try {
      final response = await _supabaseClient.from('user_pocket').select();

      return response.map((e) => UserPocketModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserPocket> getById(int id) async {
    try {
      final response = await _supabaseClient
          .from('user_pocket')
          .select()
          .eq(
            'id',
            id,
          )
          .single();

      return UserPocketModel.fromJson(response);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserPocket> update(UserPocket entity) async {
    try {
      final response = await _supabaseClient
          .from('user_pocket')
          .upsert(
            entity.toJson(),
          )
          .select();
      return UserPocketModel.fromJson(response.first);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
