import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:presensi_pintar_ta/utils/client_api.dart';
import 'package:reactive_file_picker/reactive_file_picker.dart';

class LeaveService {
  Future createLeave(Map<String, Object?> data) async {
    try {
      MultiFile<String>? document = data['document'] as MultiFile<String>?;

      var postData = FormData.fromMap({
        'type': data['type'],
        'dates': data['dates'],
        'reason': data['reason'],
      });

      if (document != null) {
        postData.files.add(MapEntry(
          'document',
          await MultipartFile.fromFile(
            document.platformFiles.first.path!,
            filename: document.platformFiles.first.name,
          ),
        ));
      }

      final response = await clientApi().post('/leave', data: postData);
      final resData = json.decode(response.data.toString());
      return resData;
    } on DioError catch (e) {
      final error = json.decode(e.response?.data);
      return Future.error(error['message']);
    }
  }

  Future createAnnualLeaves(Map<String, Object?> data) async {
    try {
      final postData = json.encode({'dates': data['dates']});

      final response = await clientApi().post('/leave/annual', data: postData);
      final resData = json.decode(response.data.toString());
      return resData;
    } on DioError catch (e) {
      final error = json.decode(e.response?.data);
      return Future.error(error['message']);
    }
  }

  Future getLeave() async {
    try {
      final response = await clientApi().get('/leave');
      final resData = json.decode(response.data.toString());
      return resData['data'];
    } on DioError catch (e) {
      final error = json.decode(e.response?.data);
      return Future.error(error['message']);
    }
  }

  Future getAnnualLeave() async {
    try {
      final response = await clientApi().get('/leave/annual');
      final resData = json.decode(response.data.toString());
      return resData['data'];
    } on DioError catch (e) {
      final error = json.decode(e.response?.data);
      return Future.error(error['message']);
    }
  }
}
