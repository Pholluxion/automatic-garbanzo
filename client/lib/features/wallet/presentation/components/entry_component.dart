import 'package:client/features/wallet/domain/domain.dart';

class EntryComponent implements Component {

  const EntryComponent(this.entry);
  final Entry entry;

  @override
  void add(Component component) {
    throw 'Not supported';
  }

  @override
  String getName() {
    return entry.description;
  }

  @override
  bool isComposite() {
    return false;
  }

  @override
  void remove(Component component) {
    throw 'Not supported';
  }

  @override
  List<Component> get components => throw 'Not supported';
}
