import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:waterreminder/constant/constant.dart';
import 'package:waterreminder/data/platform/platform_messenger.dart';

class WaterRepository {
  WaterRepository() {
    PlatformMessenger.setMethodCallHandler((call) {
      switch (call.method) {
        case Constant.methodWaterChanged:
          _waterMilliliters.add(call.arguments);
          break;
        case Constant.methodNotificationEnabledChanged:
          _notificationEnabled.add(call.arguments);
          break;
        default:
          break;
      }
      return Future.value(null);
    });
  }

  final _waterMilliliters = BehaviorSubject<int>();
  final _notificationEnabled = BehaviorSubject<bool>();

  Stream<int> get waterMilliliters => _waterMilliliters.stream;
  Stream<bool> get notificationEnabled => _notificationEnabled.stream;

  void drinkWater(int milliliters) {
    PlatformMessenger.invokeMethod(Constant.methodDrinkWater, milliliters);
  }

  void changeNotificationEnabled(bool enabled) {
    PlatformMessenger.invokeMethod(
        Constant.methodChangeNotificationEnabled, enabled);
  }

  void subscribeToDataStore() {
    PlatformMessenger.invokeMethod(Constant.methodSubscribeToDataStore);
  }

  void close() {
    _waterMilliliters.close();
    _notificationEnabled.close();
  }
}
