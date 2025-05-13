import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:vehicle_manager/models/vehicle_info.dart';

class VehicleInformationAdapter extends TypeAdapter<VehicleInformation> {
  static const int staticTypeId = 0;

  @override
  final int typeId = staticTypeId;

  @override
  VehicleInformation read(BinaryReader reader) {
    try {
      final int length = reader.readByte();
      Map<int, dynamic> data = {};

      for (int i = 0; i < length; i++) {
        int key = reader.readByte();
        Object? value = reader.read();

        if (value == null) {
          throw Exception("Unexpected null value for key '$key' "
              "while reading InstrumentData from disk");
        }
        data[key] = value;
      }

      return VehicleInformation(
          company: data[0],
          brand: data[1],
          model: data[2],
          vehicleType: VehicleType.values[data[3]],
          images: data[4],
          videos: data[5],
          registrationInfo: data[6],
          id: data[7]);
    } catch (error, stack) {
      log(
          "Exception occurred while "
          "reading VehicleInformation from disk",
          error: error,
          stackTrace: stack);
      rethrow;
    }
  }

  @override
  void write(BinaryWriter writer, VehicleInformation obj) {
    try {
      writer
        ..writeByte(8)
        ..writeByte(0)
        ..write(obj.company)
        ..writeByte(1)
        ..write(obj.brand)
        ..writeByte(2)
        ..write(obj.model)
        ..writeByte(3)
        ..write(obj.vehicleType.index)
        ..writeByte(4)
        ..write(obj.images)
        ..writeByte(5)
        ..write(obj.videos)
        ..writeByte(6)
        ..write(obj.registrationInfo)
        ..writeByte(7)
        ..write(obj.id);
    } catch (error, stack) {
      log(
          "Exception occurred while "
          "writing VehicleInformation to disk",
          error: error,
          stackTrace: stack);
      rethrow;
    }
  }
}

class VehicleRegistrationInfoAdapter
    extends TypeAdapter<RegistrationInformation> {
  static const int staticTypeId = 1;

  @override
  final int typeId = staticTypeId;

  @override
  RegistrationInformation read(BinaryReader reader) {
    try {
      final int length = reader.readByte();
      Map<int, dynamic> data = {};

      for (int i = 0; i < length; i++) {
        int key = reader.readByte();
        Object? value = reader.read();

        if (value == null) {
          throw Exception("Unexpected null value for key '$key' "
              "while reading InstrumentData from disk");
        }
        data[key] = value;
      }

      return RegistrationInformation(vehicleNumber: data[0]);
    } catch (error, stack) {
      log(
          "Exception occurred while "
          "reading VehicleRegistrationInfo from disk",
          error: error,
          stackTrace: stack);
      rethrow;
    }
  }

  @override
  void write(BinaryWriter writer, RegistrationInformation obj) {
    try {
      writer
        ..writeByte(1)
        ..writeByte(0)
        ..write(obj.vehicleNumber);
    } catch (error, stack) {
      log(
          "Exception occurred while "
          "writing VehicleRegistrationInfo to disk",
          error: error,
          stackTrace: stack);
      rethrow;
    }
  }
}
