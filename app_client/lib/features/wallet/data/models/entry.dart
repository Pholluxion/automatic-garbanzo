import 'package:app_client/features/wallet/domain/domain.dart';

class EntryModel extends Entry implements Mappeable<Entry, EntryModel> {
  const EntryModel({
    super.id,
    required super.pocketId,
    required super.description,
    required super.amount,
    required super.date,
    required super.type,
  });

  factory EntryModel.fromJson(Map<String, dynamic> data) {
    return EntryModel(
      id: data['id'],
      pocketId: data['id_pocket'],
      description: data['description'],
      amount: data['amount'],
      date: DateTime.parse(data['date']),
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
      date: entity.date,
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
      date: model.date,
      type: model.type,
    );
  }
}
