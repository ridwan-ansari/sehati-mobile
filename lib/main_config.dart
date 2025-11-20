// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter/foundation.dart';

class MainConfig {
  Future<void> configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) return;
    tz.initializeTimeZones();
    if (Platform.isWindows) return;
    final timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone.identifier));
    print('🕒 Timezone set to: ${timeZone.identifier}');
  }
}
