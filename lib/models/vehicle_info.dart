final class VehicleInformation {
  final String company;
  final String brand;
  final String model;
  final VehicleType vehicleType;
  final List<String> images;
  final List<String> videos;
  final RegistrationInformation registrationInfo;
  final String id;

  VehicleInformation({
    required this.id,
    required this.company,
    required this.brand,
    required this.model,
    required this.vehicleType,
    required this.images,
    required this.videos,
    required this.registrationInfo,
  });

  VehicleInformation deepCopy() {
    return VehicleInformation(
      id: id,
      company: company,
      brand: brand,
      model: model,
      vehicleType: vehicleType,
      images: [...images],
      videos: [...videos],
      registrationInfo: registrationInfo.deepCopy(),
    );
  }
}

final class RegistrationInformation {
  final String vehicleNumber;

  RegistrationInformation({required this.vehicleNumber});

  RegistrationInformation deepCopy() {
    return RegistrationInformation(vehicleNumber: vehicleNumber);
  }
}

enum VehicleType { motorBike, motorCar }

extension Name on VehicleType {
  String get displayName {
    switch (this) {
      case VehicleType.motorBike:
        return "Motor Bike";
      case VehicleType.motorCar:
        return "Motor Car";
    }
  }
}
