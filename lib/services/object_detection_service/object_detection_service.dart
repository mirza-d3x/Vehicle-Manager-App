import 'dart:io';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class ObjectDetectorService {
  final ObjectDetector _objectDetector = ObjectDetector(
    options: ObjectDetectorOptions(
      mode: DetectionMode.single,
      classifyObjects: true,
      multipleObjects: true,
    ),
  );

  Future<List<DetectedObject>> detectObjectsFromFile(File file) async {
    final inputImage = InputImage.fromFile(file);
    return await _objectDetector.processImage(inputImage);
  }

  void dispose() {
    _objectDetector.close();
  }
}
