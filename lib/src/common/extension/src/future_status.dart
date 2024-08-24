import 'package:mobx/mobx.dart';

extension FutureStatusX on FutureStatus {
  bool get isPending => this == FutureStatus.pending;
  bool get isRejected => this == FutureStatus.rejected;
  bool get isFulfilled => this == FutureStatus.fulfilled;
}
