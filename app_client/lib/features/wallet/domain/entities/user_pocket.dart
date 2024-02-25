import 'package:app_client/features/wallet/domain/domain.dart';

class UserPocket implements Entity<UserPocket> {
  final int id;
  final int idPocket;
  final String idUser;

  UserPocket({required this.id, required this.idPocket, required this.idUser});

  @override
  UserPocket copyWith(Map<String, dynamic> data) {
    return UserPocket(
      id: data['id'] ?? id,
      idPocket: data['id_pocket'] ?? idPocket,
      idUser: data['id_user'] ?? idUser,
    );
  }

  @override
  List<Object?> get props => [id, idPocket, idUser];

  @override
  bool? get stringify => true;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id_pocket': idPocket,
      'id_user': idUser,
    };
  }
}
