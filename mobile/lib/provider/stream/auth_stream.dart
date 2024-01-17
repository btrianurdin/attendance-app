import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensi_pintar_ta/services/api/auth_service.dart';
import 'package:presensi_pintar_ta/services/api/profile_service.dart';
import 'package:presensi_pintar_ta/services/locator/token_service.dart';
import 'package:presensi_pintar_ta/services/locator/locator.dart';

class AuthStream {
  final StreamController<dynamic> _onAuthStateChange =
      StreamController.broadcast();

  final _profileService = ProfileService();
  final _authService = AuthService();
  final _tokenService = locator<TokenService>();

  Stream<dynamic> get onAuthStateChange => _onAuthStateChange.stream;

  Future login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _authService.login(email: email, password: password);
      await _tokenService.setToken(res['token']);
      final profile = await _profileService.profile();
      _onAuthStateChange.add(profile);
    } on String catch (e) {
      Fluttertoast.showToast(msg: e);
    }
  }

  Future logout() async {
    try {
      await _authService.logout();
      await _tokenService.removeToken();
      _onAuthStateChange.add(null);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Gagal logout');
    }
  }

  Future forceLogout() async {
    await _tokenService.removeToken();
    _onAuthStateChange.add(null);
  }
}
