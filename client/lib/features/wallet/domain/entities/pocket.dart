import 'package:intl/intl.dart';

import 'package:client/features/wallet/domain/domain.dart';

class Pocket implements Entity<Pocket> {

  const Pocket({
    required this.id,
    required this.idBudget,
    required this.amount,
    required this.name,
    required this.description,
    required this.createdAt,
  });
  final int id;
  final int idBudget;
  final double amount;
  final String name;
  final String description;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        createdAt,
        amount,
      ];

  String get formattedAmount {
    final simpleCurrency = NumberFormat.decimalPatternDigits(
      decimalDigits: 0,
    );
    return simpleCurrency.format(amount);
  }

  String get createdAtFormatted {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(createdAt);
  }

  Pocket copyWith({
    int? id,
    int? idBudget,
    double? amount,
    String? name,
    String? description,
    DateTime? createdAt,
  }) {
    return Pocket(
      id: id ?? this.id,
      idBudget: idBudget ?? this.idBudget,
      amount: amount ?? this.amount,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'description': description,
      'id_budget': idBudget,
    };
  }

  @override
  bool? get stringify => true;
}
