import 'package:intl/intl.dart';

import 'package:client/features/wallet/domain/domain.dart';

class Entry implements Entity<Entry> {
  final int id;
  final int pocketId;
  final String description;
  final double amount;
  final DateTime createdAt;
  final EntryType type;

  const Entry({
    this.id = 0,
    required this.pocketId,
    required this.description,
    required this.amount,
    required this.createdAt,
    required this.type,
  });

  @override
  List<Object?> get props => [id, description, amount, createdAt, type];

  String get dateFormatted {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(createdAt);
  }

  String get formattedAmount {
    final simpleCurrency = NumberFormat.decimalPatternDigits(
      decimalDigits: 0,
    );
    return simpleCurrency.format(amount);
  }

  @override
  Entry copyWith(Map<String, dynamic> data) {
    return Entry(
      id: data['id'] ?? id,
      pocketId: data['id_pocket'] ?? pocketId,
      description: data['description'] ?? description,
      amount: data['amount'] ?? amount,
      createdAt: data['created_at'] ?? createdAt,
      type: data['type'] ?? type,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id_pocket': pocketId,
      'description': description,
      'amount': amount,
      'type': type.name,
    };
  }

  @override
  bool? get stringify => true;
}
