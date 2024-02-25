import 'package:app_client/features/wallet/domain/domain.dart';

class Budget implements Entity<Budget> {
  final int id;
  final String name;
  final String description;
  final DateTime createdAt;

  Budget({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  @override
  Budget copyWith(Map<String, dynamic> data) {
    return Budget(
      id: data['id'] ?? id,
      name: data['name'] ?? name,
      description: data['description'] ?? description,
      createdAt: data['created_at'] ?? createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, description];

  @override
  bool? get stringify => true;

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }
}
