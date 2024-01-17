import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class CameraService {
  CameraController? _cameraController;
  InputImageRotation? _cameraRotation;
  String? _imagePath;

  CameraController? get cameraController => _cameraController;
  InputImageRotation? get cameraRotation => _cameraRotation;
  String? get imagePath => _imagePath;

  Future initialize() async {
    if (_cameraController != null) return;
    CameraDescription cameraDesc = await _getCameraAvailable();
    _cameraController =
        CameraController(cameraDesc, ResolutionPreset.high, enableAudio: false);
    await _cameraController?.initialize();
    _cameraRotation = _rotationImage(cameraDesc.sensorOrientation);
  }

  Future<CameraDescription> _getCameraAvailable() async {
    List<CameraDescription> cameras = await availableCameras();
    return cameras.firstWhere((CameraDescription camera) =>
        camera.lensDirection == CameraLensDirection.front);
  }

  InputImageRotation _rotationImage(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  Future<XFile?> takePicture() async {
    await _cameraController?.stopImageStream();
    XFile? picture = await _cameraController?.takePicture();
    _imagePath = picture?.path;
    return picture;
  }

  void dispose() async {
    if (_cameraController == null) return;
    _cameraController?.dispose();
    _cameraController = null;
  }
}
