import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:vehicle_manager/services/service_locator/service_locator.dart';
import 'package:vehicle_manager/app/app_features/home/screen/home_screen_routebuilder.dart';

void main() {
  runZonedGuarded<void>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await ServiceLocator.instance.initialize();

    runApp(const VehicleManagerApp());
  }, (error, stack) {
    log(
        "Uncaught Exception occurred. "
        "This exception is uncaught at place where it was thrown",
        error: error,
        stackTrace: stack);
  });
}

class VehicleManagerApp extends StatefulWidget {
  const VehicleManagerApp({super.key});

  @override
  State<VehicleManagerApp> createState() => _VehicleManagerAppState();
}

class _VehicleManagerAppState extends State<VehicleManagerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: HomeScreenRouteBuilder(),
    );
  }
}
