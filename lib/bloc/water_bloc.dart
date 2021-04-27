import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterreminder/domain/model/water_input.dart';
import 'package:waterreminder/domain/model/water_settings.dart';
import 'package:waterreminder/domain/repository/water_repository.dart';

class WaterBloc extends Cubit<WaterSettings> {
  WaterBloc(this._repository) : super(WaterSettings.initial()) {
    _subscription = _repository.waterSettings.listen((event) {
      emit(event);
    });
  }

  final WaterRepository _repository;
  StreamSubscription? _subscription;

  int get currentWater => state.currentMilliliters;
  int get remainigWater =>
      state.currentMilliliters <= state.recommendedMilliliters
          ? state.recommendedMilliliters - state.currentMilliliters
          : 0;
  double get progress =>
      state.currentMilliliters / state.recommendedMilliliters;

  Future<void> drinkWater(WaterInput input) async {
    _repository.drinkWater(input.milliliters);
  }

  void changeAlarmEnabled(bool enabled) {
    _repository.changeAlarmEnabled(enabled);
  }

  void setRecommendedMilliliters(int milliliters) {
    _repository.setRecommendedMilliliters(milliliters);
  }

  void clearDataStore() {
    _repository.clearDataStore();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
