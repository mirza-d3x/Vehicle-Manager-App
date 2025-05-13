import 'package:vehicle_manager/services/database_service/vehicle_database.dart';

final class ServiceLocator {
  static ServiceLocator? _instance;
  final VehicleDatabase _vehicleInfoDatabase;

  const ServiceLocator._internal(this._vehicleInfoDatabase);

  VehicleDatabase get vehicleDatabase => _vehicleInfoDatabase;

  Future<void> initialize() async {
    await _vehicleInfoDatabase.initialize();
  }

  static ServiceLocator get instance =>
      _instance ??= ServiceLocator._internal(VehicleDatabase());
}
