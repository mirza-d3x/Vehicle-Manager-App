import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_manager/app/app_features/media_capture/cubit/media_capture_cubit.dart';
import 'package:vehicle_manager/app/app_features/vehicle_details/screen/components/vehicle_details_initial.dart';

class MediaCaptureInitialComponent extends StatelessWidget {
  final CameraController controller;
  final MediaType mediaType;
  const MediaCaptureInitialComponent(
      {required this.controller, required this.mediaType, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Align(
            alignment: Alignment.topCenter,
            child: CameraPreview(controller,
                child: CenterTargetWidget(mediaType: mediaType)),
          ),
        ),
        Expanded(
          child: mediaType == MediaType.image
              ? ImageCaptureControlls(controller: controller)
              : VideoCaptureControlls(controller: controller),
        ),
      ],
    );
  }
}

class CenterTargetWidget extends StatelessWidget {
  final MediaType mediaType;
  const CenterTargetWidget({required this.mediaType, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text(
              "Place the target in the center of the camera",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.yellow, fontWeight: FontWeight.w500),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: constraints.smallest.longestSide * 0.6,
                      width: constraints.smallest.longestSide * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.yellow, width: 2.5),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Press the button to capture ${mediaType.displayName}",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class ImageCaptureControlls extends StatefulWidget {
  final CameraController controller;

  const ImageCaptureControlls({required this.controller, super.key});

  @override
  State<ImageCaptureControlls> createState() => _ImageCaptureControllsState();
}

class _ImageCaptureControllsState extends State<ImageCaptureControlls> {
  bool imageProcessing = false;

  void performImageCapture() {
    if (imageProcessing) return;
    imageProcessing = true;
    context
        .read<MediaCaptureCubit>()
        .performImageCapture(context, () => imageProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: Offset(0, -size.height * 0.035),
          child: Align(
            alignment: Alignment.center,
            child: buildCaptureButton(size),
          ),
        ),
      ],
    );
  }

  Widget buildCaptureButton(Size size) {
    return SizedBox(
      height: size.height * 0.095,
      width: size.height * 0.095,
      child: ElevatedButton(
        onPressed: performImageCapture,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: BorderSide(color: Colors.white, width: 2.5),
            ),
            backgroundColor: Colors.red),
        child: SizedBox.shrink(),
      ),
    );
  }
}

class VideoCaptureControlls extends StatefulWidget {
  final CameraController controller;
  const VideoCaptureControlls({required this.controller, super.key});

  @override
  State<VideoCaptureControlls> createState() => _VideoCaptureControllsState();
}

class _VideoCaptureControllsState extends State<VideoCaptureControlls> {
  bool videoProcecssing = false;

  void performImageCapture() {
    if (videoProcecssing) return;
    videoProcecssing = true;
    context
        .read<MediaCaptureCubit>()
        .performImageCapture(context, () => videoProcecssing = false);
  }

  void handleVideoCapture() async {
    final cubit = context.read<MediaCaptureCubit>();
    await cubit.perfomVIdeoRecording(
      context,
      () => setState(() => videoProcecssing = true),
      () => setState(() => videoProcecssing = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: Offset(0, -size.height * 0.035),
          child: Align(
            alignment: Alignment.center,
            child: buildVideoCaptureButton(size),
          ),
        ),
      ],
    );
  }

  Widget buildVideoCaptureButton(Size size) {
    return SizedBox(
      height: size.height * 0.095,
      width: size.height * 0.095,
      child: ElevatedButton(
        onPressed: handleVideoCapture,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: Colors.white, width: 2.5),
          ),
          backgroundColor: videoProcecssing ? Colors.white : Colors.red,
        ),
        child: Icon(
          videoProcecssing ? Icons.stop : Icons.fiber_manual_record,
          size: 50,
          color: videoProcecssing ? Colors.red : Colors.white,
        ),
      ),
    );
  }
}
