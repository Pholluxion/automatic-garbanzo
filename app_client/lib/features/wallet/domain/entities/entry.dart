import 'package:app_client/features/wallet/domain/domain.dart';

class Entry implements Entity<Entry> {
  final int id;
  final int pocketId;
  final String description;
  final double amount;
  final DateTime date;
  final EntryType type;

  const Entry({
    this.id = 0,
    required this.pocketId,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
  });

  @override
  List<Object?> get props => [id, description, amount, date, type];

  String get formattedDate => '${date.day}/${date.month}/${date.year}';

  @override
  Entry copyWith(Map<String, dynamic> data) {
    return Entry(
      id: data['id'] ?? id,
      pocketId: data['id_pocket'] ?? pocketId,
      description: data['description'] ?? description,
      amount: data['amount'] ?? amount,
      date: data['date'] ?? date,
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
