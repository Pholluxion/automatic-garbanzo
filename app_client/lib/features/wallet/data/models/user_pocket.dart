import 'package:app_client/features/wallet/domain/domain.dart';

class UserPocketModel extends UserPocket implements Mappeable<UserPocket, UserPocketModel> {
  UserPocketModel({
    required super.id,
    required super.idPocket,
    required super.idUser,
  });

  factory UserPocketModel.fromJson(Map<String, dynamic> map) {
    return UserPocketModel(
      id: map['id'],
      idPocket: map['id_pocket'],
      idUser: map['id_user'],
    );
  }

  @override
  UserPocketModel entityToModel(UserPocket entity) {
    return UserPocketModel(
      id: entity.id,
      idPocket: entity.idPocket,
      idUser: entity.idUser,
    );
  }

  @override
  UserPocket modelToEntity(UserPocketModel model) {
    return UserPocket(
      id: model.id,
      idPocket: model.idPocket,
      idUser: model.idUser,
    );
  }
}
