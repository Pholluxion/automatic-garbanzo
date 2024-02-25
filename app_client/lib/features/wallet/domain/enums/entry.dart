enum EntryType {
  income,
  expense;

  String get name {
    switch (this) {
      case EntryType.income:
        return 'income';
      case EntryType.expense:
        return 'expense';
    }
  }

  static EntryType fromName(String name) {
    switch (name) {
      case 'income':
        return EntryType.income;
      case 'expense':
        return EntryType.expense;
      default:
        throw Exception('Invalid name');
    }
  }
}
