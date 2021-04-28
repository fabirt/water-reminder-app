import 'dart:io';

import 'package:flutter/services.dart';
import 'package:waterreminder/constant/constant.dart';

class PlatformMessenger {
  PlatformMessenger._();
  static const _platformCahnnel = MethodChannel(Constant.platformChannelName);

  static void invokeMethod(String method, [dynamic arguments]) {
    if (Platform.isAndroid) {
      _platformCahnnel.invokeMethod(method, arguments);
    }
  }

  static void setMethodCallHandler(Future<dynamic> Function(MethodCall) call) {
    if (Platform.isAndroid) {
      _platformCahnnel.setMethodCallHandler(call);
    }
  }
}
