import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:presensi_pintar_ta/model/location_model.dart';
import 'package:presensi_pintar_ta/services/api/attendance_service.dart';
import 'package:presensi_pintar_ta/views/widgets/presence/check_location.dart';
import 'package:presensi_pintar_ta/views/widgets/presence/presence_camera.dart';

class PresencePage extends StatefulWidget {
  const PresencePage({super.key, this.arguments});

  final dynamic arguments;

  @override
  State<PresencePage> createState() => _PresencePageState();
}

class _PresencePageState extends State<PresencePage> {
  bool _successLocation = false;
  LocationModel? location;

  final _attendanceService = AttendanceService();

  Future _determinePosition(LocationModel location) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error({'msg': 'Lokasi tidak aktif', 'status': 1});
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(
            {'msg': 'Akses lokasi tidak diizinkan', 'status': 2});
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          {'msg': 'Location permissions are permanently denied.', 'status': 3});
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final getDistance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      double.parse(location.latitude ?? ''),
      double.parse(location.longitude ?? ''),
    );

    if (getDistance > location.radius!) {
      return Future.error({
        'msg': 'Anda berada diluar radius ${location.radius} meter',
        'status': 4
      });
    }
    await Future.delayed(Duration(seconds: 2));
    return Future.value({'msg': 'Lokasi berhasil ditemukan', 'status': 0});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _successLocation
          ? null
          : _attendanceService.check(widget.arguments['type']),
      builder: (context, snapshoot) {
        if (!_successLocation &&
            snapshoot.connectionState == ConnectionState.waiting) {
          return _preparationLoading();
        }
        if (snapshoot.hasError) {
          Fluttertoast.showToast(msg: snapshoot.error.toString());
          Future.delayed(const Duration(milliseconds: 200)).then((value) {
            Navigator.pop(context);
          });
          return _preparationLoading();
        }

        List faces = snapshoot.data['faces'];

        faces = faces.map((face) => json.decode(face)).toList();
        LocationModel location =
            LocationModel.fromJson(snapshoot.data['location']);

        return FutureBuilder(
          future: _determinePosition(location),
          builder: (context, snapshot) {
            if (!_successLocation) {
              return CheckLocation(
                snapshot: snapshot,
                onRefresh: () {
                  setState(() {});
                },
                onSuccess: _onHasData,
              );
            }

            return PresenceCamera(
              faceCode: faces,
              type: widget.arguments['type'],
            );
          },
        );
      },
    );
  }

  _preparationLoading() {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  _onHasData() {
    Future.delayed(const Duration(seconds: 2)).then((value) {
      setState(() {
        _successLocation = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _successLocation = false;
  }
}
