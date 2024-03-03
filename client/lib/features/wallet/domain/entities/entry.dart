import 'package:intl/intl.dart';

import 'package:client/features/wallet/domain/domain.dart';

class Entry implements Entity<Entry> {

  const Entry({
    this.id = 0,
    required this.pocketId,
    required this.description,
    required this.amount,
    required this.createdAt,
    required this.type,
  });
  final int id;
  final int pocketId;
  final String description;
  final double amount;
  final DateTime createdAt;
  final EntryType type;

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

  Entry copyWith({
    int? id,
    int? pocketId,
    String? description,
    double? amount,
    DateTime? createdAt,
    EntryType? type,
  }) {
    return Entry(
      id: id ?? this.id,
      pocketId: pocketId ?? this.pocketId,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id_pocket': pocketId,
      'description': description,
      'amount': amount,
      'created_at': createdAt.toIso8601String(),
      'type': type.name,
    };
  }

  @override
  bool? get stringify => true;
}
