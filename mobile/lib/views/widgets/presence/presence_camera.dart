import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:presensi_pintar_ta/services/locator/camera_service.dart';
import 'package:presensi_pintar_ta/services/locator/detector_service.dart';
import 'package:presensi_pintar_ta/services/locator/recognition_service.dart';
import 'package:presensi_pintar_ta/services/locator/locator.dart';
import 'package:presensi_pintar_ta/utils/debug_print.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:presensi_pintar_ta/views/widgets/components/camera_view.dart';
import 'package:presensi_pintar_ta/views/widgets/presence/presence_process.dart';

enum PresenceCameraType { checkIn, checkOut }

class PresenceCamera extends StatefulWidget {
  const PresenceCamera({super.key, required this.faceCode, required this.type});

  final List? faceCode;
  final String type;

  @override
  State<PresenceCamera> createState() => _PresenceCameraState();
}

class _PresenceCameraState extends State<PresenceCamera> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _cameraService = locator<CameraService>();
  final _detectorService = locator<DetectorService>();
  final _recognitionService = locator<RecognitionService>();

  bool _isInitializing = false;
  bool _isDetecting = false;
  bool _isFaceMatch = false;
  Face? faceResult;
  int falseRecognize = 0;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future _start() async {
    setState(() => _isInitializing = true);
    await _cameraService.initialize();
    await _recognitionService.initialize();
    _detectorService.initialize();
    setState(() => _isInitializing = false);

    _detecting();
  }

  void _detecting() {
    _cameraService.cameraController?.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        if (_isDetecting) return;
        if (_isFaceMatch) return;

        _isDetecting = true;

        try {
          await _detectorService.detect(image);
          setState(() {});
          if (_detectorService.faces.isNotEmpty &&
              _detectorService.isFaceAtBox()) {
            if (widget.faceCode != null && !_isFaceMatch) {
              print('masuk mengenali wajah....');

              final hasil = _recognitionService.predictUser(
                image,
                _detectorService.faces[0],
                widget.faceCode!,
              );

              if (hasil) {
                _isFaceMatch = true;
              } else {
                _isFaceMatch = false;
                falseRecognize++;
              }
            }
          }
          _isDetecting = false;
          setState(() {});
        } catch (e) {
          _isDetecting = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    dd('render presence camera');
    if (_isFaceMatch) {
      // Future.microtask(() {
      //   Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (context) => PresenceProcess(
      //         type: widget.type,
      //       ),
      //     ),
      //     (route) => false,
      //   );
      // });
      return PresenceProcess(
        type: widget.type,
      );
      // return Container();
    } else {
      return CameraView(
        scaffoldKey: scaffoldKey,
        isInitializing: _isInitializing,
        isTakePic: false,
        overflow: _message(),
      );
    }
  }

  Widget _message() {
    if (falseRecognize >= 10) {
      return SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Colors.yellow.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            width: screen(context).width * 0.9,
            height: 70,
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(
                'Cerahkan layar ponsel Anda dan cari tempat yang terang',
                style: blackTextStyle.copyWith(
                    fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }
    return Container();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _recognitionService.dispose();
    _detectorService.dispose();
    super.dispose();
  }
}
