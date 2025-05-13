import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:vehicle_manager/app/app_features/media_view/media_veiw_routebuilder.dart';
import 'package:vehicle_manager/app/app_features/vehicle_details/screen/components/vehicle_details_initial.dart';
import 'package:vehicle_manager/services/object_detection_service/object_detection_service.dart';

part 'media_capture_state.dart';

class MediaCaptureCubit extends Cubit<MediaCaptureState> {
  late final CameraController cameraController;
  final MediaType _mediaType;

  MediaCaptureCubit({required MediaType mediaType})
      : _mediaType = mediaType,
        super(MediaCaptureLoading()) {
    initializeCameraController();
  }

  Future<void> initializeCameraController() async {
    try {
      if (state is! MediaCaptureLoading) {
        _sinkLoadingState();
      }

      List<CameraDescription> cameraDescList = await availableCameras();
      CameraDescription? targetCameraDesc;

      for (var cameraDesc in cameraDescList) {
        if (cameraDesc.lensDirection == CameraLensDirection.back) {
          targetCameraDesc = cameraDesc;
          break;
        }
      }
      if (targetCameraDesc == null) {
        throw CameraException("1", "No back camera found");
      }
      cameraController =
          CameraController(targetCameraDesc, ResolutionPreset.max);

      await cameraController.initialize();

      _sinkIntialState();
    } catch (error, stack) {
      log(
          "Exception occurred while "
          "initializing camera controller",
          error: error,
          stackTrace: stack);
      _sinkErrorState("Something went wrong, Please try again.");
    }
  }

  void performImageCapture(
      BuildContext context, VoidCallback onImageCaptured) async {
    try {
      XFile imageFile = await cameraController.takePicture();
      File imagefile = File(imageFile.path);

      // final detector = ObjectDetectorService();

      // final results = await detector.detectObjectsFromFile(imagefile);
      final List<String> detectedLabels = [];
      // for (var obj in results) {
      //   for (var label in obj.labels) {
      //     detectedLabels.add(label.text);
      //   }
      // }

      final InputImage inputImage = InputImage.fromFile(imagefile);
      final ImageLabeler labeler =
          ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.5));
      final labels = await labeler.processImage(inputImage);

      for (final label in labels) {
        log("Detected: ${label.label}, confidence: ${label.confidence}");
        detectedLabels.add(label.label);
      }

      onImageCaptured();

      if (!context.mounted) return;

      bool? choosen = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MediaVeiwRoutebuilder(
            mediaFile: imagefile,
            mediaType: MediaType.image,
            showBottomBar: true,
            detectedObjects: detectedLabels,
          ),
        ),
      );

      if (choosen != null && choosen && context.mounted) {
        Navigator.of(context).pop<File>(imagefile);
      }
    } catch (error, stack) {
      log(
          "Exception occurred "
          "while performing Image Capture",
          error: error,
          stackTrace: stack);
    }
  }

  Future<void> perfomVIdeoRecording(
    BuildContext context,
    VoidCallback onRecordingStarted,
    VoidCallback onVideoCaptured,
  ) async {
    try {
      if (cameraController.value.isRecordingVideo) {
        // Stop recording
        XFile videoFile = await cameraController.stopVideoRecording();
        File file = File(videoFile.path);
        onVideoCaptured();

        if (!context.mounted) return;

        bool? choosen = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MediaVeiwRoutebuilder(
              mediaFile: file,
              mediaType: MediaType.video,
              showBottomBar: true,
            ),
          ),
        );

        if (choosen != null && choosen && context.mounted) {
          Navigator.of(context).pop<File>(file);
        }
      } else {
        // Start recording
        await cameraController.startVideoRecording();
        onRecordingStarted();
      }
    } catch (e, stack) {
      log("Error in toggleVideoRecording", error: e, stackTrace: stack);
    }
  }

  void _sinkIntialState() => emit(MediaCaptureInitial(mediaType: _mediaType));

  void _sinkLoadingState() => emit(MediaCaptureLoading());

  void _sinkErrorState(String errorMessage) =>
      emit(MediaCaptureError(errorMessage: errorMessage));

  @override
  Future<void> close() {
    cameraController.dispose();
    return super.close();
  }
}
