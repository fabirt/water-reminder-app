import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterreminder/domain/repository/water_repository.dart';

class NotificationBloc extends Cubit<bool> {
  NotificationBloc(this._repository) : super(true) {
    _subscription = _repository.notificationEnabled.listen((event) {
      emit(event);
    });
  }

  final WaterRepository _repository;
  StreamSubscription? _subscription;

  void changeEnabled(bool enabled) {
    _repository.changeNotificationEnabled(enabled);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
