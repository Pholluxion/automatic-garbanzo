import 'package:app_client/features/wallet/domain/domain.dart';

abstract class EntryRepository implements ReadableWithParams<Entry, int>, Readable<Entry>, Writable<Entry> {}
