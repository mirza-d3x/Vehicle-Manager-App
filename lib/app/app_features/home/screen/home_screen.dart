import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_manager/app/app_features/home/cubit/home_cubit.dart';
import 'package:vehicle_manager/app/app_features/home/screen/components/home_error.dart';
import 'package:vehicle_manager/app/app_features/home/screen/components/home_initial.dart';
import 'package:vehicle_manager/app/app_features/home/screen/components/home_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Home screen",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w500))),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            switch (state) {
              case HomeLoadingState():
                return HomeLoadingComponent();
              case HomeInitialState():
                return HomeInitialComponent(
                    vehicleInfoList: state.vehicleInfoList);
              case HomeErrorState():
                return HomeErrorComponent(
                    errorMessage: state.errorMessage,
                    onRetry:
                        context.read<HomeCubit>().initializeWithVehicleInfo);
            }
          },
        ),
      ),
    );
  }
}
