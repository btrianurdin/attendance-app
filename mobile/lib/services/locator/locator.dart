import 'package:get_it/get_it.dart';
import 'package:presensi_pintar_ta/services/api/attendance_service.dart';
import 'package:presensi_pintar_ta/provider/stream/auth_stream.dart';
import 'package:presensi_pintar_ta/services/locator/detector_service.dart';
import 'package:presensi_pintar_ta/services/locator/activation_service.dart';
import 'package:presensi_pintar_ta/services/locator/token_service.dart';
import 'package:presensi_pintar_ta/services/locator/navigation_service.dart';
import 'package:presensi_pintar_ta/services/locator/recognition_service.dart';
import 'camera_service.dart';

final locator = GetIt.instance;

void serviceInit() {
  locator.registerLazySingleton<CameraService>(() => CameraService());
  locator.registerLazySingleton<DetectorService>(() => DetectorService());
  locator.registerLazySingleton<RecognitionService>(() => RecognitionService());
  locator.registerLazySingleton<TokenService>(() => TokenService());
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<AuthStream>(() => AuthStream());
  locator.registerLazySingleton<ActivationService>(() => ActivationService());
}