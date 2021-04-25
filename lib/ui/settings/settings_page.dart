import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterreminder/bloc/notification_bloc.dart';
import 'package:waterreminder/ui/settings/rolling_switch_button.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<NotificationBloc>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32 + 64 + 40, top: 32.0),
        child: Column(
          children: [
            SizedBox(width: double.infinity),
            Text(
              "Settings",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text("Reminders"),
                  ),
                  RollingSwitchButton(
                    value: bloc.state,
                    colorOff: Theme.of(context).errorColor,
                    onChange: (value) => bloc.changeEnabled(value),
                  ),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
