import 'package:presensi_pintar_ta/model/division_model.dart';

class PositionModel {
  int? id;
  String? name;
  String? shiftId;
  DivisionModel? division;

  PositionModel({this.id, this.name, this.shiftId, this.division});

  factory PositionModel.fromJson(json) {
    return PositionModel(
      id: json['id'],
      name: json['name'],
      shiftId: json['shiftId'],
      division: json['division'] != null
          ? DivisionModel.fromJson(json['division'])
          : null,
    );
  }
}
