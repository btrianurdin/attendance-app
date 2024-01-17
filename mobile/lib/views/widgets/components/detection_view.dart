import 'package:flutter/material.dart';
import 'package:presensi_pintar_ta/services/locator/camera_service.dart';
import 'package:presensi_pintar_ta/services/locator/detector_service.dart';
import 'package:presensi_pintar_ta/services/locator/recognition_service.dart';
import 'package:presensi_pintar_ta/services/locator/locator.dart';
import 'package:presensi_pintar_ta/views/widgets/components/camera_view.dart';

class DetectionView extends StatefulWidget {
  const DetectionView({super.key});

  @override
  State<DetectionView> createState() => _DetectionViewState();
}

class _DetectionViewState extends State<DetectionView> {
  final _cameraService = locator<CameraService>();
  final _detectorService = locator<DetectorService>();
  final _recognitionService = locator<RecognitionService>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isInitializing = false;
  bool _isTakePic = false;

  @override
  void initState() {
    _start();
    super.initState();
  }

  Future _start() async {
    setState(() => _isInitializing = true);
    await _cameraService.initialize();
    await _recognitionService.initialize();
    _detectorService.initialize();
    setState(() => _isInitializing = false);
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      scaffoldKey: scaffoldKey,
      isInitializing: _isInitializing,
      isTakePic: _isTakePic,
    );
  }
}
