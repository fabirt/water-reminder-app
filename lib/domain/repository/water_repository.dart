import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:waterreminder/constant/constant.dart';
import 'package:waterreminder/data/platform/platform_messenger.dart';
import 'package:waterreminder/domain/model/water_settings.dart';

class WaterRepository {
  WaterRepository() {
    PlatformMessenger.setMethodCallHandler((call) {
      switch (call.method) {
        case Constant.methodWaterSettingsChanged:
          _waterSettings.add(WaterSettings.fromMap(call.arguments));
          break;
        default:
          break;
      }
      return Future.value(null);
    });
  }

  final _waterSettings = BehaviorSubject<WaterSettings>();

  Stream<WaterSettings> get waterSettings => _waterSettings.stream;

  void drinkWater(int milliliters) {
    PlatformMessenger.invokeMethod(Constant.methodDrinkWater, milliliters);
  }

  void changeAlarmEnabled(bool enabled) {
    PlatformMessenger.invokeMethod(
        Constant.methodChangeNotificationEnabled, enabled);
  }

  void subscribeToDataStore() {
    PlatformMessenger.invokeMethod(Constant.methodSubscribeToDataStore);
  }

  void setRecommendedMilliliters(int milliliters) {
    PlatformMessenger.invokeMethod(
        Constant.methodSetRecommendedMilliliters, milliliters);
  }

  void clearDataStore() {
    PlatformMessenger.invokeMethod(Constant.methodClearDataStore);
  }

  void close() {
    _waterSettings.close();
  }
}
