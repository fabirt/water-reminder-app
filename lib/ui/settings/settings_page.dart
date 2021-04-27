import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:waterreminder/bloc/water_bloc.dart';
import 'package:waterreminder/ui/settings/rolling_switch_button.dart';
import 'package:waterreminder/util/dialog.dart';
import 'package:waterreminder/util/num_extension.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<WaterBloc>();
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32 + 64 + 40, top: 32.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(width: double.infinity),
              Text(
                "Settings",
                style: theme.textTheme.headline4,
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: Text("Reminders"),
                  ),
                  RollingSwitchButton(
                    value: bloc.state.alarmEnabled,
                    colorOff: theme.errorColor,
                    onChange: (value) => bloc.changeAlarmEnabled(value),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: Text("Daily consumption"),
                  ),
                  Text(bloc.state.recommendedMilliliters.asMilliliters()),
                ],
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => clearDataStore(context),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        theme.errorColor.withOpacity(0.06)),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Hard Reset",
                        style: theme.textTheme.bodyText2?.copyWith(
                          color: theme.errorColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> clearDataStore(BuildContext context) async {
    final confirmed = await showConfirmationDialog(context);
    if (confirmed) {
      context.read<WaterBloc>().clearDataStore();
    }
  }
}
