import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensi_pintar_ta/provider/store_provider.dart';
import 'package:presensi_pintar_ta/services/api/attendance_service.dart';
import 'package:presensi_pintar_ta/services/locator/locator.dart';
import 'package:presensi_pintar_ta/services/locator/navigation_service.dart';
import 'package:presensi_pintar_ta/utils/debug_print.dart';
import 'package:provider/provider.dart';

class PresenceProcess extends StatefulWidget {
  const PresenceProcess({super.key, required this.type});

  final String type;

  @override
  State<PresenceProcess> createState() => _PresenceProcessState();
}

class _PresenceProcessState extends State<PresenceProcess> {
  final _attendanceService = AttendanceService();
  final _navigatorService = locator<NavigationService>().navigator!;

  int render = 0;

  @override
  void initState() {
    super.initState();

    _presence();
  }

  Future _presence() async {
    dd('_presence process');
    try {
      dynamic response;
      if (render == 0) {
        if (widget.type == 'in') {
          response = await _attendanceService.checkIn();
        } else {
          response = await _attendanceService.checkOut();
        }
      }

      Fluttertoast.showToast(
        msg: response,
      );
    } on DioError catch (e) {
      final response = jsonDecode(e.response?.data);
      Fluttertoast.showToast(msg: response['message']);
    } finally {
      context.read<UserStore>().attendance?.isFetched = false;
      _navigatorService.pushNamedAndRemoveUntil('/layout', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
