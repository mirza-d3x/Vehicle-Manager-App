part of 'home_cubit.dart';

@immutable
sealed class HomeState {
  const HomeState();
}

final class HomeLoadingState extends HomeState {}

final class HomeInitialState extends HomeState {
  final List<VehicleInformation> vehicleInfoList;

  const HomeInitialState({required this.vehicleInfoList});
}

final class HomeErrorState extends HomeState {
  final String errorMessage;

  const HomeErrorState({required this.errorMessage});
}
