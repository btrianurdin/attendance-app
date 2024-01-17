import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:presensi_pintar_ta/utils/client_api.dart';

class ProfileService {
  Future profile() async {
    try {
      final response = await clientApi().get('/profile');
      final data = json.decode(response.data.toString());

      return data['data'];
    } on DioError {
      return Future.error({});
    }
  }

  Future faces() async {
    final response = await clientApi().get('/profile/face');
    final data = json.decode(response.data.toString());
    return data;
  }

  Future changePassword(Map<String, Object?> data) async {
    final postData = json.encode({
      'current_password': data['current'],
      'new_password': data['new'],
      'new_password_confirmation': data['confirm'],
    });

    final response = await clientApi().put(
      '/profile/password',
      data: postData,
    );
    final res = json.decode(response.data.toString());
    return res;
  }
}
