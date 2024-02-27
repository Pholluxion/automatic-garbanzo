import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:client/core/utils/tables.dart';
import 'package:client/features/wallet/data/data.dart';
import 'package:client/features/wallet/domain/domain.dart';

class PocketRepositoryImpl implements PocketRepository {
  final SupabaseClient _supabaseClient;

  PocketRepositoryImpl(this._supabaseClient);

  @override
  Future<bool> create(Pocket entity) async {
    try {
      final response = await _supabaseClient
          .from(Tables.pocket)
          .insert(
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
      await _supabaseClient.from(Tables.pocket).delete().eq(
            'id',
            id,
          );

      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Pocket>> getAll() async {
    try {
      final response = await _supabaseClient.from(Tables.pocket).select();

      return response.map((e) => PocketModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Pocket> getById(int id) async {
    try {
      final response = await _supabaseClient
          .from(
            Tables.pocket,
          )
          .select()
          .eq(
            'id',
            id,
          );

      return PocketModel.fromJson(response.first);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> update(Pocket entity) async {
    try {
      final response = await _supabaseClient
          .from(Tables.pocket)
          .update(
            entity.toJson(),
          )
          .eq(
            'id',
            entity.id,
          );

      return response.isNotEmpty;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Pocket>> getAllById(int params) async {
    try {
      final response = await _supabaseClient.from(Tables.pocket).select().eq(
            'id_budget',
            params,
          );

      return response.map((e) => PocketModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
