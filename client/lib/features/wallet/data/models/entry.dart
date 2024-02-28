import 'package:client/features/wallet/domain/domain.dart';

class EntryModel extends Entry implements Mappeable<Entry, EntryModel> {
  const EntryModel({
    super.id,
    required super.pocketId,
    required super.description,
    required super.amount,
    required super.createdAt,
    required super.type,
  });

  factory EntryModel.fromJson(Map<String, dynamic> data) {
    return EntryModel(
      id: data['id'],
      pocketId: data['id_pocket'],
      description: data['description'] ?? '',
      amount: data['amount'],
      createdAt: DateTime.parse(data['created_at']),
      type: EntryType.fromName(data['type']),
    );
  }

  @override
  EntryModel entityToModel(Entry entity) {
    return EntryModel(
      id: entity.id,
      pocketId: entity.pocketId,
      description: entity.description,
      amount: entity.amount,
      createdAt: entity.createdAt,
      type: entity.type,
    );
  }

  @override
  Entry modelToEntity(EntryModel model) {
    return Entry(
      id: model.id,
      pocketId: model.pocketId,
      description: model.description,
      amount: model.amount,
      createdAt: model.createdAt,
      type: model.type,
    );
  }
}
