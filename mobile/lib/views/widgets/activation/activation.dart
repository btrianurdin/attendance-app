import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:presensi_pintar_ta/services/locator/activation_service.dart';
import 'package:presensi_pintar_ta/services/locator/camera_service.dart';
import 'package:presensi_pintar_ta/services/locator/detector_service.dart';
import 'package:presensi_pintar_ta/services/locator/recognition_service.dart';
import 'package:presensi_pintar_ta/services/locator/locator.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:presensi_pintar_ta/views/widgets/activation/take_picture_sheet.dart';
import 'package:presensi_pintar_ta/views/widgets/components/camera_view.dart';
import 'package:presensi_pintar_ta/views/widgets/components/button.dart';

class Activation extends StatefulWidget {
  const Activation({super.key});

  @override
  State<Activation> createState() => _ActivationState();
}

class _ActivationState extends State<Activation> {
  final _cameraService = locator<CameraService>();
  final _detectorService = locator<DetectorService>();
  final _recognitionService = locator<RecognitionService>();
  final _activationService = locator<ActivationService>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isInitializing = false;

  bool _isTakePic = false;
  bool _isDetecting = false;
  bool _isNextBtnLoading = false;
  bool _isIdentify = false;
  bool _showWarning = true;
  Face? faceResult;

  List<Map<String, String>> warning = [
    {'text': 'Hadapkan wajah ke depan kamera.', 'img': 'assets/face-front.png'},
    {
      'text': 'Putarkan wajah 30 derajat ke arah kanan',
      'img': 'assets/face-right.png'
    },
    {
      'text': 'Putarkan wajah 30 derajat ke arah kiri',
      'img': 'assets/face-left.png'
    },
  ];
  Timer? _timer;

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
    _detecting();
  }

  void _detecting() {
    _cameraService.cameraController?.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        if (_showWarning) return;
        if (_isDetecting) return;

        _isDetecting = true;

        try {
          await _detectorService.detect(image);

          if (_detectorService.faces.isNotEmpty &&
              _detectorService.isFaceAtBox()) {
            setState(() {
              faceResult = _detectorService.faces[0];
            });
            if (_isIdentify) {
              _recognitionService.predict(image, _detectorService.faces[0]);
              setState(() {
                _isIdentify = false;
              });
            }
          } else {
            setState(() {
              faceResult = null;
            });
          }
          _isDetecting = false;
        } catch (e) {
          _isDetecting = false;
        }
      }
    });
  }

  Future onTakeCamera() async {
    if (faceResult == null) return;
    _isIdentify = true;
    setState(() {
      _isNextBtnLoading = true;
    });
    PersistentBottomSheetController<dynamic>? controller;
    try {
      await Future.delayed(const Duration(milliseconds: 700));
      await _cameraService.takePicture();
      setState(() {
        _isTakePic = true;
      });
      controller = scaffoldKey.currentState
          ?.showBottomSheet((context) => const TakePictureSheet());
    } catch (e) {
      Fluttertoast.showToast(msg: 'Gagal mengambil gambar!');
      _reload();
      controller?.close();
    }
    controller?.closed.whenComplete(_reload);
  }

  void _reload() {
    // reset when reload
    _recognitionService.dispose();
    _detectorService.dispose();
    setState(() {
      _isTakePic = false;
      _isNextBtnLoading = false;
      faceResult = null;
    });
    if (_activationService.isNext) {
      setState(() {
        _showWarning = true;
      });
      _activationService.resetNext();
    }
    _start();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: cancelActivation,
      child: CameraView(
        scaffoldKey: scaffoldKey,
        isInitializing: _isInitializing,
        isTakePic: _isTakePic,
        overflow: overflowCamera(),
        floatingButton: !_isTakePic
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Button(
                  onPressed: onTakeCamera,
                  label: 'TAKE ${_activationService.activeState + 1}',
                  isLoading: _isNextBtnLoading,
                  isDisabled: faceResult == null,
                ),
              )
            : Container(),
      ),
    );
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _recognitionService.dispose();
    _detectorService.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Widget overflowCamera() {
    if (_showWarning) {
      _timer = Timer(const Duration(seconds: 3), () {
        if (!mounted) return;
        setState(() {
          _showWarning = false;
        });
      });
      return SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Step',
                    style: whiteTextStyle.copyWith(fontSize: 24),
                  ),
                  Stack(
                    children: [
                      Text(
                        '${_activationService.activeState + 1}',
                        style: whiteTextStyle.copyWith(
                          fontSize: 100,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 10
                            ..color = Colors.black,
                        ),
                      ),
                      Text(
                        '${_activationService.activeState + 1}',
                        style: whiteTextStyle.copyWith(
                          fontSize: 100,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
    }
    return Container();
  }

  Future<bool> cancelActivation() async {
    bool willLeave = false;
    // show the confirm dialog
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Batalkan aktivasi?',
          style: blackTextStyle.copyWith(fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              willLeave = true;
              _activationService.dispose();
              Navigator.of(context).pop();
            },
            child: const Text('Ya'),
          ),
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tidak'))
        ],
      ),
    );
    return willLeave;
  }
}
