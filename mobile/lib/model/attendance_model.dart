import 'package:presensi_pintar_ta/model/shift_model.dart';

enum AttendanceStatus { present, late, leave, sickLeave, annualLeave }

class Type {
  static const present = '';
}

class AttendanceModel {
  int? id;
  String? date;
  String? checkIn;
  String? checkOut;
  int? workHour;
  AttendanceStatus? status;
  ShiftDetailModel? shift;

  AttendanceModel({
    this.id,
    this.date,
    this.checkIn,
    this.checkOut,
    this.workHour,
    this.status,
    this.shift,
  });

  factory AttendanceModel.fromJson(json) {
    return AttendanceModel(
      id: json['id'],
      date: json['date'],
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      workHour: json['work_hour'],
      status: json['status'] != null ? _castingStatus(json['status']) : null,
      shift: json['shift'] != null
          ? ShiftDetailModel.fromJson(json['shift'])
          : null,
    );
  }

  String get statusStr {
    if (status == AttendanceStatus.late) return 'terlambat';
    if (status == AttendanceStatus.present) return 'tepat waktu';
    if (status == AttendanceStatus.leave) return 'izin';
    if (status == AttendanceStatus.sickLeave) return 'izin sakit';
    if (status == AttendanceStatus.annualLeave) return 'cuti';
    return '';
  }

  static List<AttendanceModel> toLists(List data) {
    return data.map((e) => AttendanceModel.fromJson(e)).toList();
  }

  static AttendanceStatus? _castingStatus(String type) {
    if (type == 'PRESENT') return AttendanceStatus.present;
    if (type == 'LATE') return AttendanceStatus.late;
    if (type == 'LAEAVE') return AttendanceStatus.leave;
    if (type == 'SICK_LEAVE') return AttendanceStatus.sickLeave;
    if (type == 'ANNUAL_LEAVE') return AttendanceStatus.annualLeave;
    return null;
  }
}
