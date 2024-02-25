import 'package:intl/intl.dart';

import 'package:client/features/wallet/domain/domain.dart';

class Pocket implements Entity<Pocket> {
  final int id;
  final int idBudget;
  final double amount;
  final String name;
  final String description;
  final DateTime createdAt;

  const Pocket({
    required this.id,
    required this.idBudget,
    required this.amount,
    required this.name,
    required this.description,
    required this.createdAt,
  });

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

  @override
  Pocket copyWith(Map<String, dynamic> data) {
    return Pocket(
      id: data['id'] ?? id,
      idBudget: data['id_budget'] ?? idBudget,
      amount: data['amount'] ?? amount,
      name: data['name'] ?? name,
      description: data['description'] ?? description,
      createdAt: data['created_at'] ?? createdAt,
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
