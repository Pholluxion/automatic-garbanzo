import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:client/core/utils/tables.dart';
import 'package:client/features/wallet/data/data.dart';
import 'package:client/features/wallet/domain/domain.dart';

class EntryRepositoryImpl implements EntryRepository {
  final SupabaseClient _supabaseClient;

  EntryRepositoryImpl(this._supabaseClient);

  @override
  Future<bool> create(Entry entry) async {
    try {
      final response = await _supabaseClient
          .from(Tables.entry)
          .insert(
            entry.toJson(),
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
      await _supabaseClient.from(Tables.entry).delete().eq(
            'id',
            id,
          );

      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Entry>> getAll() async {
    try {
      final response = await _supabaseClient.from(Tables.entry).select();

      return response.map((e) => EntryModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Entry> getById(int id) async {
    try {
      final response = await _supabaseClient
          .from(
            Tables.entry,
          )
          .select()
          .eq(
            'id',
            id,
          );
      return EntryModel.fromJson(response.first);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Entry> update(Entry entry) async {
    try {
      final response = await _supabaseClient
          .from(Tables.entry)
          .update(entry.toJson())
          .eq(
            'id',
            entry.id,
          )
          .select('id');

      return EntryModel.fromJson(response.first);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Entry>> getAllById(int params) async {
    try {
      final response = await _supabaseClient.from(Tables.entry).select().eq('id_pocket', params);
      return response.map((e) => EntryModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
