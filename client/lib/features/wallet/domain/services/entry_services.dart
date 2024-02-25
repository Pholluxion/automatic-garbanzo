import 'package:client/features/wallet/domain/domain.dart';

abstract class EntryService implements ReadableWithParams<Entry, int>, Readable<Entry>, Writable<Entry> {}
