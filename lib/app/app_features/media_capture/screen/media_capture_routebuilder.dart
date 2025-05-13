import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_manager/app/app_features/media_capture/cubit/media_capture_cubit.dart';
import 'package:vehicle_manager/app/app_features/media_capture/screen/media_capture_screen.dart';
import 'package:vehicle_manager/app/app_features/vehicle_details/screen/components/vehicle_details_initial.dart';

class MediaCaptureRoutebuilder extends StatelessWidget {
  final MediaType mediaType;
  const MediaCaptureRoutebuilder({required this.mediaType, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => MediaCaptureCubit(mediaType: mediaType),
        lazy: true,
        child: const MediaCaptureScreen());
  }
}
