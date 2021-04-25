import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterreminder/domain/model/water_input.dart';
import 'package:waterreminder/domain/repository/water_repository.dart';

class WaterBloc extends Cubit<int> {
  WaterBloc(this._repository) : super(0) {
    _subscription = _repository.waterMilliliters.listen((event) {
      emit(event);
    });
  }

  final WaterRepository _repository;
  static const _dailyMilliliters = 2000;
  StreamSubscription? _subscription;

  int get currentWater => state;
  int get remainigWater =>
      state <= _dailyMilliliters ? _dailyMilliliters - state : 0;
  double get progress => state / _dailyMilliliters;

  Future<void> drinkWater(WaterInput input) async {
    _repository.drinkWater(input.milliliters);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
