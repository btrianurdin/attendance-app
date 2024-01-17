import 'package:presensi_pintar_ta/utils/debug_print.dart';

enum LeaveType { leave, sick, annual }

enum LeaveStatus { pending, approved, rejected }

class LeaveModel {
  int? id;
  LeaveType? type;
  String? submissionDate;
  String? reason;
  String? document;
  LeaveStatus? status;
  int? employeeId;
  List<LeaveDetailModel>? leaveDetails;

  LeaveModel({
    this.id,
    this.type,
    this.submissionDate,
    this.reason,
    this.document,
    this.status,
    this.employeeId,
    this.leaveDetails,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['id'],
      type: json['type'] == 'LEAVE'
          ? LeaveType.leave
          : json['type'] == 'SICK_LEAVE'
              ? LeaveType.sick
              : LeaveType.annual,
      submissionDate: json['submission_date'],
      reason: json['reason'],
      document: json['document'],
      status: json['status'] == 'PENDING'
          ? LeaveStatus.pending
          : json['status'] == 'APPROVED'
              ? LeaveStatus.approved
              : LeaveStatus.rejected,
      employeeId: json['employee_id'],
      leaveDetails: LeaveDetailModel.toLists(json['leave_details']),
    );
  }

  static List<LeaveModel> toLists(List<dynamic> data) {
    return data.map((e) => LeaveModel.fromJson(e)).toList();
  }
}

class LeaveDetailModel {
  String? date;
  int? leaveId;

  LeaveDetailModel({
    this.date,
    this.leaveId,
  });

  factory LeaveDetailModel.fromJson(Map<String, dynamic> json) =>
      LeaveDetailModel(
        date: json['date'],
        leaveId: json['leave_id'],
      );

  static List<LeaveDetailModel> toLists(List<dynamic> data) {
    dd('check ${data}');
    return data.map((e) => LeaveDetailModel.fromJson(e)).toList();
  }
}
