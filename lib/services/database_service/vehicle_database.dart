import 'dart:developer';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vehicle_manager/models/vehicle_info.dart';
import 'package:vehicle_manager/services/database_service/database_provider.dart';
import 'package:vehicle_manager/services/database_service/vehicle_info_adapter.dart';

final class VehicleDatabase
    implements DataBaseprovider<VehicleInformation, String> {
  late LazyBox<VehicleInformation> _vehicleInfoBox;

  @override
  Future<void> initialize() async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);

      Hive.registerAdapter(VehicleInformationAdapter());
      Hive.registerAdapter(VehicleRegistrationInfoAdapter());

      _vehicleInfoBox =
          await Hive.openLazyBox<VehicleInformation>("vehicleInfo");
    } catch (error, stack) {
      log(
          "Exception occurred while "
          "initializing Database",
          error: error,
          stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> create(
      {required String? key, required VehicleInformation data}) async {
    try {
      if (!_vehicleInfoBox.containsKey(key)) {
        await _vehicleInfoBox.put(key, data);
      }
    } catch (error, stack) {
      log(
          "Exception occurred while "
          "creating Data in Database",
          error: error,
          stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<List<VehicleInformation>> retrieve(
      {required Iterable<String>? keys}) async {
    try {
      List<VehicleInformation> vehicleInfoList = [];
      Iterable<dynamic> getKeys = keys ?? _vehicleInfoBox.keys;

      for (String key in getKeys) {
        VehicleInformation? info = await _vehicleInfoBox.get(key);
        if (info != null) {
          vehicleInfoList.add(info);
        }
      }

      return vehicleInfoList;
    } catch (error, stack) {
      log(
          "Exception occurred while "
          "retrieving Data from Database",
          error: error,
          stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> update(
      {required String? key, required VehicleInformation data}) async {
    try {
      if (_vehicleInfoBox.containsKey(key)) {
        await _vehicleInfoBox.put(key, data);
      }
    } catch (error, stack) {
      log(
          "Exception occurred while "
          "updating Data in Database",
          error: error,
          stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> delete({required String? key}) async {
    try {
      await _vehicleInfoBox.delete(key);
    } catch (error, stack) {
      log(
          "Exception occurred while "
          "deleting Data from Database",
          error: error,
          stackTrace: stack);
      rethrow;
    }
  }
}
