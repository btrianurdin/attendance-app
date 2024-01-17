import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:presensi_pintar_ta/utils/debug_print.dart';
import 'package:presensi_pintar_ta/utils/image_converter.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;
import 'package:permission_handler/permission_handler.dart';

class RecognitionService {
  Interpreter? _interpreter;
  List _predictResult = [];

  List? get predictResult => _predictResult;

  Future initialize() async {
    try {
      Delegate gpuDelegate = GpuDelegateV2(
        options: GpuDelegateOptionsV2(
          isPrecisionLossAllowed: false,
          inferencePreference: TfLiteGpuInferenceUsage.fastSingleAnswer,
          inferencePriority1: TfLiteGpuInferencePriority.minLatency,
          inferencePriority2: TfLiteGpuInferencePriority.auto,
          inferencePriority3: TfLiteGpuInferencePriority.auto,
        ),
      );

      var interpreterOptions = InterpreterOptions()..addDelegate(gpuDelegate);
      _interpreter = await Interpreter.fromAsset(
        'mobilefacenet.tflite',
        options: interpreterOptions,
      );
    } catch (e) {
      // ignore: avoid_print
      print("ERROR WHEN LOAD MODEL $e");
      // ignore: avoid_print
      print(e);
    }
  }

  void predict(CameraImage image, Face? face) {
    if (_interpreter == null) return;
    if (face == null) return;

    List inputImage = _recognize(image, face);
    inputImage = inputImage.reshape([1, 112, 112, 3]);
    List output = List.generate(1, (index) => List.filled(192, 0));
    // proses pengenalan wajah
    _interpreter?.run(inputImage, output);
    output = output.reshape([192]);

    _predictResult = List.from(output);
  }

   List _recognize(CameraImage image, Face face) {
    imglib.Image convert = convertToImage(image);
    imglib.Image rotate = imglib.copyRotate(convert, -90);

    double x = face.boundingBox.left - 35;
    double y = face.boundingBox.top - 20;
    double w = face.boundingBox.width + 50;
    double h = face.boundingBox.height + 60;

    imglib.Image crop = imglib.copyCrop(
      rotate,
      x.round(),
      y.round(),
      w.round(),
      h.round(),
    );

    // imglib.PngEncoder pngEncoder = imglib.PngEncoder();

    // String path = '/storage/emulated/0/MyApp';

    // bool isGrand = await Permission.manageExternalStorage.isGranted;
    // if (!isGrand) {
    //   await Permission.manageExternalStorage.request();
    // }
    imglib.Image resize = imglib.copyResizeCropSquare(crop, 112);

    // List<int> pngCrop = pngEncoder.encodeImage(crop);
    // List<int> png = pngEncoder.encodeImage(resize);
    // File('$path/face-recog-${DateTime.now().microsecondsSinceEpoch}.png').writeAsBytesSync(pngCrop, flush: true);
    // File('$path/face-recog-${DateTime.now().millisecond}.png').writeAsBytesSync(png, flush: true);

    Float32List imgList = _imageToByteListFloat32(resize);

    return imgList;
  }

  Float32List _imageToByteListFloat32(imglib.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  bool predictUser(CameraImage image, Face? face, List faceCode) {
    predict(image, face);

    if (_predictResult.isEmpty) return false;
    double minDist = 999;
    double currDist = 0.0;
    bool isIdentified = false;

    for (var i = 0; i < faceCode.length; i++) {
      currDist = euclideanDistance(faceCode[i], _predictResult);
      dd(currDist);
      if (currDist <= 0.5 && currDist < minDist) {
        minDist = currDist;
        isIdentified = true;
      }
    }
    return isIdentified;
  }

  double euclideanDistance(List e1, List e2) {
    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow((e1[i] - e2[i]), 2);
    }
    return sqrt(sum);
  }

  emptyPredict() {
    _predictResult = [];
  }

  reset() {
    _predictResult = [];
    _interpreter?.close();
  }

  dispose() {
    _predictResult = [];
    _interpreter?.close();
  }
}
