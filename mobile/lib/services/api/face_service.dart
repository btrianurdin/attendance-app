import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:presensi_pintar_ta/utils/client_api.dart';

class FaceService {
  Future addFaces(List faces) async {
    try {
      final mapData = {"face_code": faces};
      final postData = json.encode(mapData);

      final response = await clientApi().post('/face', data: postData);
      final data = json.decode(response.data.toString());
      return data;
    } on DioError catch (e) {
      final error = json.decode(e.response?.data);
      return Future.error(error['message']);
    }
  }
}
