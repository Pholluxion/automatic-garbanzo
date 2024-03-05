import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:client/core/utils/tables.dart';
import 'package:client/features/wallet/data/data.dart';
import 'package:client/features/wallet/domain/domain.dart';

class BudgetRepositoryImpl extends BudgetRepository {
  BudgetRepositoryImpl(this._supabaseClient);
  final SupabaseClient _supabaseClient;

  @override
  Future<bool> create(Budget entity) async {
    try {
      final response = await _supabaseClient
          .from(Tables.budget)
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
      await _supabaseClient.from(Tables.budget).delete().eq(
            'id',
            id,
          );

      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Budget>> getAll() async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id ?? '';
      final response = await _supabaseClient
          .from(
            Tables.userBudget,
          )
          .select('id_user, budget(*)')
          .filter('id_user', 'eq', userId);

      return response.map((e) => BudgetModel.fromJson(e['budget'])).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Budget> getById(int id) async {
    try {
      final response = await _supabaseClient
          .from(
            Tables.budget,
          )
          .select()
          .eq(
            'id',
            id,
          );

      return BudgetModel.fromJson(response.first);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> update(Budget entity) async {
    try {
      final response = await _supabaseClient.from(Tables.budget).update(entity.toJson()).eq('id', entity.id).select();
      return response.isNotEmpty;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
