import 'package:client/features/wallet/domain/domain.dart';

class PocketComponent implements Component {
  final Pocket pocket;
  final List<Component> _componentes;

  const PocketComponent({
    required this.pocket,
    required List<Component> componentes,
  }) : _componentes = componentes;

  @override
  void add(Component component) {
    _componentes.add(component);
  }

  @override
  String getName() {
    return pocket.name;
  }

  @override
  bool isComposite() {
    return true;
  }

  @override
  void remove(Component component) {
    _componentes.remove(component);
  }

  @override
  List<Component> get components => _componentes;
}
