import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:waterreminder/bloc/water_bloc.dart';
import 'package:waterreminder/domain/repository/water_repository.dart';
import 'package:waterreminder/ui/home/home_page.dart';
import 'package:waterreminder/ui/theme/app_theme.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _repository = WaterRepository();

  @override
  void initState() {
    super.initState();
    _repository.subscribeToDataStore();
  }

  @override
  void dispose() {
    _repository.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WaterBloc(_repository),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Water Reminder',
        theme: AppTheme.light,
        home: AnnotatedRegion(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: HomePage(),
        ),
      ),
    );
  }
}
