import 'package:client/features/wallet/domain/domain.dart';

class BudgetComponent implements Component {

  BudgetComponent({
    required this.budget,
    required List<Component> componentes,
  }) : _componentes = componentes;
  final Budget budget;
  final List<Component> _componentes;

  @override
  void add(Component component) {
    _componentes.add(component);
  }

  @override
  String getName() {
    return budget.name;
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
