import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_manager/app/app_features/media_capture/cubit/media_capture_cubit.dart';
import 'package:vehicle_manager/app/app_features/media_capture/screen/components/media_capture_initial.dart';
import 'package:vehicle_manager/app/app_features/media_capture/screen/components/media_capture_loading.dart';
import 'package:vehicle_manager/app/app_features/media_capture/screen/components/media_caputure_error.dart';

class MediaCaptureScreen extends StatefulWidget {
  const MediaCaptureScreen({super.key});

  @override
  State<MediaCaptureScreen> createState() => _MediaCaptureScreenState();
}

class _MediaCaptureScreenState extends State<MediaCaptureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Media Capture",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      body: BlocBuilder<MediaCaptureCubit, MediaCaptureState>(
        builder: (context, state) {
          switch (state) {
            case MediaCaptureLoading():
              return MediaCaptureLoadingComponent();
            case MediaCaptureInitial():
              return MediaCaptureInitialComponent(
                mediaType: state.mediaType,
                controller: context.read<MediaCaptureCubit>().cameraController,
              );
            case MediaCaptureError():
              return MediaCaptureErrorComponent(
                  errorMessage: state.errorMessage,
                  onRetry: context
                      .read<MediaCaptureCubit>()
                      .initializeCameraController);
          }
        },
      ),
    );
  }
}
