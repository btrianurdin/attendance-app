import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:presensi_pintar_ta/utils/client_api.dart';

class AttendanceService {
  Future history() async {
    final response = await clientApi().get('/attendance/history');

    final data = json.decode(response.data.toString());
    return data['data'];
  }

  Future today() async {
    final response = await clientApi().get('/attendance');
    final data = json.decode(response.data.toString());
    return data['data'];
  }

  Future check(String type) async {
    try {
      Response response;
      if (type == 'in') {
        response = await clientApi().post('/attendance/pre-checkin');
      } else {
        response = await clientApi().post('/attendance/pre-checkout');
      }

      final data = json.decode(response.data.toString());
      return data['data'];
    } on DioError catch (e) {
      final error = json.decode(e.response?.data);
      return Future.error(error['message']);
    }
  }

  Future checkIn() async {
    final response = await clientApi().post('/attendance/checkin');
    final data = json.decode(response.data.toString());

    return data['message'];
  }

  Future checkOut() async {
    final response = await clientApi().post('/attendance/checkout');

    final data = json.decode(response.data.toString());
    return data['message'];
  }
}
