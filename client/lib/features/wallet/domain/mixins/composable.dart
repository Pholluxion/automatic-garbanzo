abstract class Component {
  List<Component> get components;
  String getName();
  void add(Component component);
  void remove(Component component);
  bool isComposite();
}
