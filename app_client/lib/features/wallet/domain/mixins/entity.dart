import 'package:equatable/equatable.dart';

import 'package:app_client/features/wallet/domain/domain.dart';

mixin Entity<T> on CopyWith<T>, Serializable, Equatable {}
