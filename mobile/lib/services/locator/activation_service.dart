import 'package:presensi_pintar_ta/services/locator/locator.dart';
import 'package:presensi_pintar_ta/services/locator/recognition_service.dart';

class ActivationService {
  List<List<dynamic>> _faces = [];
  int _activeState = 0;
  bool isNext = false;

  final _recognitionService = locator<RecognitionService>();

  int get activeState => _activeState;
  List<List> get faces => _faces;

  void addFaces(List<dynamic> face) {
    if (_faces.length >= 3) return;
    _faces.add(face);
  }

  void removeFaces() {
    _faces = [];
  }

  void activeNext() {
    isNext = true;
  }

  void resetNext() {
    isNext = false;
  }

  void nextActive({int? nextTo}) {
    if (nextTo != null) {
      _activeState = nextTo;
    } else {
      if (_activeState >= 2) return;
      _activeState++;
    }
  }

  void prevActive({int? prevTo}) {
    if (prevTo != null) {
      _activeState = prevTo;
    } else {
      if (_activeState <= 0) return;
      _activeState--;
    }
  }

  bool isFaceMatch() {
    if (_faces.length < 3) return false;

    final faceSample = faces[0];
    double currDist = 0.0;
    int faceNotMatch = 0;

    for (var i = 1; i < faces.length; i++) {
      currDist = _recognitionService.euclideanDistance(faceSample, faces[i]);
      if (currDist > 0.5) {
        faceNotMatch++;
      }
      print('masuk $currDist');
    }

    return faceNotMatch == 0;
  }

  dispose() {
    _activeState = 0;
    _faces = [];
    isNext = false;
  }
}
