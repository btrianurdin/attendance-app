import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:presensi_pintar_ta/services/locator/camera_service.dart';
import 'package:presensi_pintar_ta/services/locator/detector_service.dart';
import 'package:presensi_pintar_ta/services/locator/locator.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:presensi_pintar_ta/views/widgets/components/picture_view.dart';

class CameraView extends StatefulWidget {
  const CameraView({
    super.key,
    required this.scaffoldKey,
    required this.isInitializing,
    required this.isTakePic,
    this.floatingButton,
    this.overflow,
  });

  final Key scaffoldKey;
  final bool isInitializing;
  final bool isTakePic;
  final Widget? floatingButton;
  final Widget? overflow;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final _cameraService = locator<CameraService>();
  final _detectorService = locator<DetectorService>();

  GlobalKey<ScaffoldState> gkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (_cameraService.cameraController == null || widget.isInitializing) {
      return const Center(child: CircularProgressIndicator());
    }
    final render = _viewRender();

    return Scaffold(
      key: widget.scaffoldKey,
      body: Stack(
        children: [render, widget.overflow ?? Container()],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: widget.floatingButton,
    );
  }

  Widget _viewRender() {
    if (widget.isTakePic) return PictureView(image: _cameraService.imagePath!);

    final size = MediaQuery.of(context).size;
    var scale =
        size.aspectRatio * _cameraService.cameraController!.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Transform.scale(
            scale: scale,
            child: Center(
              child: CameraPreview(_cameraService.cameraController!),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.30,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.30,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.10,
              height: MediaQuery.of(context).size.height * 0.4001,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.10,
              height: MediaQuery.of(context).size.height * 0.4001,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.82,
              height: MediaQuery.of(context).size.height * 0.41,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _detectorService.isFaceAtBox()
                      ? successColor
                      : dangerColor,
                  width: 5.0,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
