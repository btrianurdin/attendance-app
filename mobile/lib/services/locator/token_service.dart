import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensi_pintar_ta/utils/storage_secure.dart';

enum TokenType { access, refresh }

class TokenService {
  final _tokenKey = 'NUTAPOS_TOKEN';

  Future setToken(String token) async {
    try {
      await storageSecure.write(key: _tokenKey, value: token);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await storageSecure.read(key: _tokenKey);
      return token;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return null;
    }
  }

  Future removeToken() async {
    try {
      await storageSecure.delete(key: _tokenKey);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
