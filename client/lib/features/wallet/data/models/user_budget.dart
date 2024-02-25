import 'package:client/features/wallet/domain/domain.dart';

class UserBudgetModel extends UserBudget implements Mappeable<UserBudget, UserBudgetModel> {
  UserBudgetModel({
    required super.id,
    required super.idBudget,
    required super.idUser,
  });

  factory UserBudgetModel.fromJson(Map<String, dynamic> map) {
    return UserBudgetModel(
      id: map['id'],
      idBudget: map['id_budget'],
      idUser: map['id_user'],
    );
  }

  @override
  UserBudgetModel entityToModel(UserBudget entity) {
    return UserBudgetModel(
      id: entity.id,
      idBudget: entity.idBudget,
      idUser: entity.idUser,
    );
  }

  @override
  UserBudget modelToEntity(UserBudgetModel model) {
    return UserBudget(
      id: model.id,
      idBudget: model.idBudget,
      idUser: model.idUser,
    );
  }
}
