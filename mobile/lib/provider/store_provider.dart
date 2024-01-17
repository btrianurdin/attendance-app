import 'package:flutter/foundation.dart';
import 'package:presensi_pintar_ta/model/attendance_model.dart';
import 'package:presensi_pintar_ta/model/face_model.dart';
import 'package:presensi_pintar_ta/model/leave_model.dart';
import 'package:presensi_pintar_ta/model/profile_model.dart';
import 'package:presensi_pintar_ta/model/schedule_model.dart';
import 'package:presensi_pintar_ta/provider/store_request_model.dart';
import 'package:presensi_pintar_ta/provider/stream/auth_stream.dart';
import 'package:presensi_pintar_ta/services/locator/locator.dart';

class UserStore extends ChangeNotifier {
  ProfileModel? _profile;
  FaceModel? _faces;

  StoreRequestModel<List<ScheduleModel>>? schedules;
  StoreRequestModel<List<AttendanceModel>>? history;
  StoreRequestModel<AttendanceModel>? attendance;
  StoreRequestModel<List<LeaveModel>>? leaves;
  StoreRequestModel<List<LeaveModel>>? annualLeaves;

  ProfileModel? get profile => _profile;
  FaceModel? get faces => _faces;
  final _authService = locator<AuthStream>();

  UserStore() {
    _authService.onAuthStateChange.listen((data) {
      if (data != null) {
        setProfile(data);
      } else {
        schedules?.reset();
        history?.reset();
        attendance?.reset();
        leaves?.reset();
        annualLeaves?.reset();
        _faces = null;
        clearProfile();
      }
    });
  }

  void setStatusActive() {
    if (_profile == null) return;
    _profile?.status = ProfileStatus.active;

    notifyListeners();
  }

  void setProfile(data) {
    _profile = ProfileModel.fromJson(data);
    notifyListeners();
  }

  void clearProfile() {
    _profile = null;
    notifyListeners();
  }

  void setHistory(data) {
    history?.data = [];
    history = StoreRequestModel<List<AttendanceModel>>(
      data: AttendanceModel.toLists(data),
      isFetched: true,
    );
  }

  void setAttendance(data) {
    attendance = null;
    if (data != null) {
      attendance = StoreRequestModel<AttendanceModel>(
        data: AttendanceModel.fromJson(data),
        isFetched: true,
      );
    }
  }

  void setSchedules(data) {
    schedules?.data = [];
    schedules = StoreRequestModel<List<ScheduleModel>>(
      data: ScheduleModel.toLists(data),
      isFetched: true,
    );
  }

  void setLeaves(data) {
    leaves?.data = [];
    leaves = StoreRequestModel<List<LeaveModel>>(
      data: LeaveModel.toLists(data),
      isFetched: true,
    );
  }

  void setAnnualLeaves(data) {
    annualLeaves?.data = [];
    annualLeaves = StoreRequestModel<List<LeaveModel>>(
      data: LeaveModel.toLists(data),
      isFetched: true,
    );
  }
}
