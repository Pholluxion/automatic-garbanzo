import 'package:app_client/features/wallet/domain/domain.dart';

class UserBudgetComponent implements Component {
  final UserBudget userBudget;
  final List<Component> _componentes;

  UserBudgetComponent({
    required this.userBudget,
    required List<Component> componentes,
  }) : _componentes = componentes;

  @override
  void add(Component component) {
    _componentes.add(component);
  }

  @override
  String getName() {
    return userBudget.idUser;
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
