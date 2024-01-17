import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensi_pintar_ta/services/locator/activation_service.dart';
import 'package:presensi_pintar_ta/services/locator/camera_service.dart';
import 'package:presensi_pintar_ta/services/locator/recognition_service.dart';
import 'package:presensi_pintar_ta/services/locator/locator.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:presensi_pintar_ta/views/widgets/activation/activation_process.dart';
import 'package:presensi_pintar_ta/views/widgets/components/button.dart';

class TakePictureSheet extends StatefulWidget {
  const TakePictureSheet({super.key});

  @override
  State<TakePictureSheet> createState() => _TakePictureSheetState();
}

class _TakePictureSheetState extends State<TakePictureSheet> {
  final _recognitionService = locator<RecognitionService>();
  final _activationService = locator<ActivationService>();
  final _cameraService = locator<CameraService>();
  bool _activeLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 480,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0),
          topLeft: Radius.circular(10.0),
        ),
        color: Colors.white,
      ),
      padding: paddingAll,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 50,
            height: 5,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: infoColor,
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_rounded, size: 22),
                const SizedBox(width: 5),
                Text(
                  "Geser ke bawah untuk membatalkan",
                  style: blackTextStyle.copyWith(fontSize: 14),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Transform(
                  transform: Matrix4.rotationY(math.pi),
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(_cameraService.imagePath!)),
                      ),
                    ),
                    width: 250,
                    height: 250,
                  ),
                ),
                Button(
                  label: _activationService.activeState == 2
                      ? 'Selesai'
                      : 'Lanjutkan',
                  color: _activationService.activeState == 2
                      ? ButtonColor.success
                      : ButtonColor.primary,
                  isLoading: _activeLoading,
                  onPressed: () {
                    if (_recognitionService.predictResult != null) {
                      _activationService
                          .addFaces(_recognitionService.predictResult!);

                      if (_activationService.activeState == 2) {
                        setState(() {
                          _activeLoading = true;
                        });

                        Future.delayed(const Duration(seconds: 2))
                            .then((value) {
                          final faceMatch = _activationService.isFaceMatch();

                          if (faceMatch) {
                            _recognitionService.emptyPredict();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => const ActivationProcess()),
                              (route) => false,
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg: "Wajah tidak cocok, silahkan mengulang.");
                            _activationService.dispose();
                            _activationService.activeNext();
                            Navigator.pop(context);
                          }
                          setState(() {
                            _activeLoading = false;
                          });
                        });
                        return;
                      }
                      _activationService.nextActive();
                      _activationService.activeNext();
                    }

                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
