import 'package:dio/dio.dart';
import 'package:presensi_pintar_ta/provider/stream/auth_stream.dart';
import 'package:presensi_pintar_ta/services/locator/navigation_service.dart';
import 'package:presensi_pintar_ta/services/locator/token_service.dart';
import 'package:presensi_pintar_ta/services/locator/locator.dart';

const baseApiUrl = 'http://192.168.100.76:8000/api';

Dio clientApi() {
  final tokenService = locator<TokenService>();
  final authStream = locator<AuthStream>();
  final navigator = locator<NavigationService>().navigator;

  Dio dio = Dio(
    BaseOptions(
      baseUrl: baseApiUrl,
      responseType: ResponseType.plain,
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (
      RequestOptions options,
      RequestInterceptorHandler handler,
    ) async {
      String? token = await tokenService.getToken();

      if (token != null) {
        options.headers['authorization'] = 'Bearer $token';
      }

      return handler.next(options);
    },
    onError: (DioError e, ErrorInterceptorHandler handler) async {
      if (e.response?.statusCode == 401) {
        final requestUri = e.requestOptions.uri.toString();
        if (requestUri.contains('/auth/logout')) {
          await authStream.logout();
          navigator?.pushNamedAndRemoveUntil('/login', (route) => false);
          return;
        }
        await authStream.forceLogout();
        navigator?.pushNamedAndRemoveUntil('/login', (route) => false);
        return;
      }

      return handler.next(e);
    },
  ));

  return dio;
}
