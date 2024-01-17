import 'package:presensi_pintar_ta/model/location_model.dart';
import 'package:presensi_pintar_ta/model/position_model.dart';

enum ProfileStatus { active, inactive, resign }

class ProfileModel {
  int? id;
  String? nip;
  String? name;
  String? email;
  String? phone;
  String? birthdate;
  String? profilePic;
  String? address;
  ProfileStatus? status;
  PositionModel? position;
  LocationModel? location;

  ProfileModel({
    this.id,
    this.nip,
    this.name,
    this.phone,
    this.email,
    this.birthdate,
    this.profilePic,
    this.address,
    this.status,
    this.position,
    this.location,
  });

  factory ProfileModel.fromJson(json) {
    return ProfileModel(
      id: json['id'],
      nip: json['nip'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      birthdate: json['birthdate'],
      profilePic: json['profile_pic'],
      address: json['address'],
      status: _castingStatus(json['status']),
      position: json['position'] != null
          ? PositionModel.fromJson(json['position'])
          : null,
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
    );
  }

  static ProfileStatus _castingStatus(String status) {
    switch (status) {
      case 'active':
        return ProfileStatus.active;
      case 'inactive':
        return ProfileStatus.inactive;
      case 'resign':
        return ProfileStatus.resign;
      default:
        return ProfileStatus.inactive;
    }
  }
}
