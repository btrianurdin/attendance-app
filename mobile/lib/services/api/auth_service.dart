import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:presensi_pintar_ta/utils/client_api.dart';

class AuthService {
  Future login({required String email, required String password}) async {
    try {
      final response = await clientApi().post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final data = json.decode(response.data.toString());

      return data['data'];
    } on DioError catch (e) {
      final msg = json.decode(e.response?.data.toString() ?? '');
      return Future.error(msg['message']);
    } catch (e) {
      return Future.error('Terjadi kesalahan');
    }
  }

  Future logout() async {
    try {
      await clientApi().post('/auth/logout');
    } on DioError catch (e) {
      return Future.error(e.response?.data);
    }
  }
}
