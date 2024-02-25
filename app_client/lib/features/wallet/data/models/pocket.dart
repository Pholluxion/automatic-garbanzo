import 'package:app_client/features/wallet/domain/domain.dart';

class PocketModel extends Pocket {
  PocketModel({
    required super.id,
    required super.name,
    required super.description,
    required super.createdAt,
  });

  factory PocketModel.fromJson(Map<String, dynamic> data) {
    return PocketModel(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      createdAt: DateTime.parse(data['created_at']),
    );
  }
}
