import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:client/core/utils/tables.dart';
import 'package:client/features/wallet/data/data.dart';
import 'package:client/features/wallet/domain/domain.dart';

class UserBudgetRepositoryImpl extends UserBudgetRepository {
  final SupabaseClient _supabaseClient;

  UserBudgetRepositoryImpl(this._supabaseClient);

  @override
  Future<bool> create(UserBudget entity) async {
    try {
      final response = await _supabaseClient
          .from(Tables.userPocket)
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
      await _supabaseClient.from(Tables.userPocket).delete().eq(
            'id',
            id,
          );

      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<UserBudget>> getAll() async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id ?? '';
      final response = await _supabaseClient
          .from(
            Tables.userPocket,
          )
          .select()
          .eq(
            'id_user',
            userId,
          );

      return response.map((e) => UserBudgetModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserBudget> getById(int id) async {
    try {
      final response = await _supabaseClient
          .from(Tables.userPocket)
          .select()
          .eq(
            'id',
            id,
          )
          .single();

      return UserBudgetModel.fromJson(response);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserBudget> update(UserBudget entity) async {
    try {
      final response = await _supabaseClient
          .from(Tables.userPocket)
          .upsert(
            entity.toJson(),
          )
          .select();
      return UserBudgetModel.fromJson(response.first);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}