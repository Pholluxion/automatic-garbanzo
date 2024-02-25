import 'package:app_client/features/wallet/domain/domain.dart';

abstract class PocketRepository implements ReadableWithParams<Pocket, int>, Readable<Pocket>, Writable<Pocket> {}
