import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_manager/app/app_features/home/cubit/home_cubit.dart';
import 'package:vehicle_manager/app/app_features/home/screen/home_screen.dart';

class HomeScreenRouteBuilder extends StatelessWidget {
  const HomeScreenRouteBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomeCubit(),
        lazy: true,
        child: const HomeScreen());
  }
}
