import 'package:app_client/features/wallet/domain/domain.dart';

class PocketModel extends Pocket {
  PocketModel({
    required super.id,
    required super.name,
    required super.amount,
    required super.idBudget,
    required super.description,
    required super.createdAt,
  });

  factory PocketModel.fromJson(Map<String, dynamic> data) {
    return PocketModel(
      id: data['id'],
      name: data['name'],
      amount: data['amount'],
      idBudget: data['id_budget'],
      description: data['description'],
      createdAt: DateTime.parse(data['created_at']),
    );
  }
}
