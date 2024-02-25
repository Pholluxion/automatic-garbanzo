import 'package:app_client/features/wallet/domain/domain.dart';

class Pocket implements Entity<Pocket> {
  final int id;
  final String name;
  final String description;
  final DateTime createdAt;

  const Pocket({
    required this.id,
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
      ];

  @override
  Pocket copyWith(Map<String, dynamic> data) {
    return Pocket(
      id: data['id'] ?? id,
      name: data['name'] ?? name,
      description: data['description'] ?? description,
      createdAt: data['created_at'] ?? createdAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }

  @override
  bool? get stringify => true;
}
