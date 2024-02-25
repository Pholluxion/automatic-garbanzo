import 'package:app_client/features/wallet/domain/domain.dart';

class UserBudget implements Entity<UserBudget> {
  final int id;
  final int idBudget;
  final String idUser;

  UserBudget({
    required this.id,
    required this.idBudget,
    required this.idUser,
  });

  @override
  UserBudget copyWith(Map<String, dynamic> data) {
    return UserBudget(
      id: data['id'] ?? id,
      idBudget: data['id_budget'] ?? idBudget,
      idUser: data['id_user'] ?? idUser,
    );
  }

  @override
  List<Object?> get props => [id, idBudget, idUser];

  @override
  bool? get stringify => true;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id_budget': idBudget,
      'id_user': idUser,
    };
  }
}
