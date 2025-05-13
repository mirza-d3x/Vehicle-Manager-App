part of 'vehicle_details_cubit.dart';

@immutable
sealed class VehicleDetailsState {
  const VehicleDetailsState();
}

final class VehicleDetailsInitial extends VehicleDetailsState {
  final VehicleType? vehicleType;
  final List<String> images;
  final List<String> videos;

  const VehicleDetailsInitial({
    required this.vehicleType,
    required this.images,
    required this.videos,
  });
}
