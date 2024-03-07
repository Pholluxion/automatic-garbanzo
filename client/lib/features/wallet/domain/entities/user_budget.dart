import 'package:client/features/wallet/domain/domain.dart';

class UserBudget implements Entity<UserBudget> {
  UserBudget({
    this.id,
    this.idBudget,
    this.idUser,
  });
  final int? id;
  final int? idBudget;
  final String? idUser;

  UserBudget copyWith({
    int? id,
    int? idBudget,
    String? idUser,
  }) {
    return UserBudget(
      id: id ?? this.id,
      idBudget: idBudget ?? this.idBudget,
      idUser: idUser ?? this.idUser,
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
