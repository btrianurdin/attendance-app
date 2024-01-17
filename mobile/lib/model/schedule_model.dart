import 'package:presensi_pintar_ta/model/shift_model.dart';

class ScheduleModel extends ShiftDetailModel {
  String? dayName;

  ScheduleModel({this.dayName, day, id, checkIn, checkOut, type})
      : super(
          day: day,
          id: id,
          checkIn: checkIn,
          checkOut: checkOut,
          type: type,
        );

  factory ScheduleModel.fromJson(json) {
    return ScheduleModel(
      dayName: json['day_name'],
      id: json['id'],
      day: json['day'],
      type: json['type'] == 'WORKDAY' ? ShiftType.workDay : ShiftType.offDay,
      checkIn: json['check_in'],
      checkOut: json['check_out'],
    );
  }

  static List<ScheduleModel> toLists(List<dynamic> data) {
    return data.map((e) => ScheduleModel.fromJson(e)).toList();
  }
}
