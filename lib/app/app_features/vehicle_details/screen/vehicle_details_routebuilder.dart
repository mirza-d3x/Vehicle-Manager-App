import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_manager/app/app_features/vehicle_details/cubit/vehicle_details_cubit.dart';
import 'package:vehicle_manager/app/app_features/vehicle_details/screen/vehicle_details_screen.dart';
import 'package:vehicle_manager/models/vehicle_info.dart';

class VehicleDetailsRouteBuilder extends StatelessWidget {
  final VehicleInformation? vehicleInfo;

  const VehicleDetailsRouteBuilder({this.vehicleInfo, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => VehicleDetailsCubit(vehicleInfo: vehicleInfo),
        lazy: true,
        child: VehicleDetailsScreen());
  }
}
