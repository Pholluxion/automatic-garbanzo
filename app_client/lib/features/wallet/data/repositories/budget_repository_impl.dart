import 'package:app_client/core/utils/tables.dart';
import 'package:app_client/features/wallet/data/data.dart';
import 'package:app_client/features/wallet/domain/domain.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BudgetRepositoryImpl extends BudgetRepository {
  final SupabaseClient _supabaseClient;

  BudgetRepositoryImpl(this._supabaseClient);

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
      final response = await _supabaseClient
          .from(
            Tables.budget,
          )
          .select();

      return response.map((e) => BudgetModel.fromJson(e)).toList();
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
  Future<Budget> update(Budget entity) async {
    try {
      final response = await _supabaseClient
          .from(Tables.budget)
          .update(
            entity.toJson(),
          )
          .eq(
            'id',
            entity.id,
          );
      return BudgetModel.fromJson(response.first);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
