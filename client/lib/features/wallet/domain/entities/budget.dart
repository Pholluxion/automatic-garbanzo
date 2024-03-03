import 'package:client/features/wallet/domain/domain.dart';

class Budget implements Entity<Budget> {

  Budget({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });
  final int id;
  final String name;
  final String description;
  final DateTime createdAt;

  Budget copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? createdAt,
  }) {
    return Budget(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, description, createdAt];

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
