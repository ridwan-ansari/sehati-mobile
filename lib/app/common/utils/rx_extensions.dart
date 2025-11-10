import 'package:get/get.dart';

extension RxDoubleExt on RxDouble {
  RxString get stringObs => RxString(value == 0 ? '' : value.toStringAsFixed(1));
}
