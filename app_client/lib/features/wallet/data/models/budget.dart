import 'package:app_client/features/wallet/domain/domain.dart';

class BudgetModel extends Budget implements Mappeable<Budget, BudgetModel> {
  BudgetModel({
    required super.id,
    required super.name,
    required super.description,
    required super.createdAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  @override
  BudgetModel entityToModel(Budget entity) {
    return BudgetModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      createdAt: entity.createdAt,
    );
  }

  @override
  Budget modelToEntity(BudgetModel model) {
    return Budget(
      id: model.id,
      name: model.name,
      description: model.description,
      createdAt: model.createdAt,
    );
  }
}
