import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:vehicle_manager/app/app_features/vehicle_details/screen/vehicle_details_routebuilder.dart';
import 'package:vehicle_manager/app/components/loader.dart';
import 'package:vehicle_manager/models/vehicle_info.dart';
import 'package:vehicle_manager/services/service_locator/service_locator.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  late final List<VehicleInformation> _vehicleInfoList;

  HomeCubit() : super(HomeLoadingState()) {
    _vehicleInfoList = List.empty(growable: true);
    initializeWithVehicleInfo();
  }

  void initializeWithVehicleInfo() async {
    try {
      if (state is! HomeLoadingState) {
        _sinkLoadingState();
      }

      List<VehicleInformation> vehicleInfoList =
          await ServiceLocator.instance.vehicleDatabase.retrieve(keys: null);

      if (vehicleInfoList.isNotEmpty) {
        _vehicleInfoList.addAll(vehicleInfoList);
      }

      _sinkInitialState();
    } catch (error, stack) {
      log(
          "Exception occurred while "
          "initializing with vehicle info",
          error: error,
          stackTrace: stack);
      _sinkErrorState("Something went wrong, Please try again.");
    }
  }

  void openVehicleDetailsPage(BuildContext context,
      {VehicleInformation? info}) async {
    int? elementIndex = info == null ? null : _vehicleInfoList.indexOf(info);

    VehicleInformation? infocopy = info?.deepCopy();

    VehicleInformation? newInfo = await Navigator.of(context)
        .push<VehicleInformation>(MaterialPageRoute(
            builder: (context) =>
                VehicleDetailsRouteBuilder(vehicleInfo: infocopy)));

    if (newInfo == null) return;

    if (elementIndex == null) {
      _vehicleInfoList.add(newInfo);
    } else {
      _vehicleInfoList[elementIndex] = newInfo;
    }

    _sinkInitialState();
  }

  void removeVehicleInfo(BuildContext context,
      {required VehicleInformation info}) async {
    try {
      CustomProgressIndicator.showLoader(context);

      try {
        if (info.images.isNotEmpty) {
          for (String imageFilePath in info.images) {
            File imageFile = File(imageFilePath);
            if (await imageFile.exists()) {
              await imageFile.delete();
            }
          }
        }
      } catch (error, stack) {
        log(
            "Exception occurred while "
            "deleting Image Media File from directory",
            error: error,
            stackTrace: stack);
      }

      try {
        if (info.videos.isNotEmpty) {
          for (String videoFilePath in info.videos) {
            File videoFile = File(videoFilePath);
            if (await videoFile.exists()) {
              await videoFile.delete();
            }
          }
        }
      } catch (error, stack) {
        log(
            "Exception occurred while "
            "deleting Video Media File from directory",
            error: error,
            stackTrace: stack);
      }

      await ServiceLocator.instance.vehicleDatabase.delete(key: info.id);

      _vehicleInfoList.remove(info);

      _sinkInitialState();
    } catch (error, stack) {
      log(
          "Exception occurred while "
          "deleting vehicle info",
          error: error,
          stackTrace: stack);
    } finally {
      if (context.mounted) {
        CustomProgressIndicator.removeLoader(context);
      }
    }
  }

  void _sinkLoadingState() => emit(HomeLoadingState());

  void _sinkInitialState() =>
      emit(HomeInitialState(vehicleInfoList: _vehicleInfoList));

  void _sinkErrorState(String errorMessage) =>
      emit(HomeErrorState(errorMessage: errorMessage));
}
