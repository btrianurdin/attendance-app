import 'package:geolocator/geolocator.dart';
import 'package:presensi_pintar_ta/model/location_model.dart';

class PresenceLocationModel {
  Position current;
  LocationModel? location;

  PresenceLocationModel({required this.current, this.location});
}
