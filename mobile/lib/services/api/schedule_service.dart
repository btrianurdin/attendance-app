import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:presensi_pintar_ta/utils/client_api.dart';

class ScheduleService {
  Future schedules() async {
    try {
      final response = await clientApi().get('/schedule');
      final data = json.decode(response.data.toString());

      return data['data'];
    } on DioError catch (e) {
      final error = json.decode(e.response?.data);
      return Future.error(error['message']);
    }
  }
}
