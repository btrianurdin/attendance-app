import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:presensi_pintar_ta/services/locator/camera_service.dart';
import 'package:presensi_pintar_ta/services/locator/locator.dart';
import 'package:camera/camera.dart';

class DetectorService {
  final CameraService _cameraService = locator<CameraService>();

  late FaceDetector _faceDetector;
  List<Face> _faces = [];

  FaceDetector get faceDetector => _faceDetector;
  List<Face> get faces => _faces;
  bool get isFaceDetected => _faces.isNotEmpty;

  void initialize() {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
        enableLandmarks: true,
      ),
    );
  }

  Future<void> detect(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation:
          _cameraService.cameraRotation ?? InputImageRotation.rotation0deg,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    _faces = await _faceDetector.processImage(inputImage);
  }

  bool isFaceAtBox() {
    if (_faces.isEmpty) return false;
    Size size = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;

    final xPositionStart = size.width * 0.15;
    final xPositionEnd = size.width - (size.width * 0.15);
    final yPositionStart = size.height * 0.30;
    final yPositionEnd = size.height - (size.height * 0.30);

    Face face = _faces[0];

    if ((face.boundingBox.left > xPositionStart &&
            face.boundingBox.left < xPositionEnd) &&
        (face.boundingBox.top > yPositionStart &&
            face.boundingBox.top < yPositionEnd)) {
      return true;
    } else {
      return false;
    }
  }

  dispose() {
    _faceDetector.close();
    _faces = [];
  }
}
