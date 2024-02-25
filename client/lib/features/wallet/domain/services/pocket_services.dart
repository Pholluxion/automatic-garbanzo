import 'package:client/features/wallet/domain/domain.dart';

abstract class PocketService implements ReadableWithParams<Pocket, int>, Readable<Pocket>, Writable<Pocket> {}
