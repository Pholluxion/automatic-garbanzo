import 'package:equatable/equatable.dart';

import 'package:client/features/wallet/domain/domain.dart';

mixin Entity<T> on CopyWith<T>, Serializable, Equatable {}
