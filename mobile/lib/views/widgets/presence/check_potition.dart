import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:presensi_pintar_ta/model/presence_location_model.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:presensi_pintar_ta/views/widgets/components/circle_pulse.dart';

class CheckPotition extends StatefulWidget {
  const CheckPotition({
    super.key,
    required this.snapshot,
    required this.onHasData,
  });

  final AsyncSnapshot<PresenceLocationModel> snapshot;
  final Function onHasData;

  @override
  State<CheckPotition> createState() => _CheckPotitionState();
}

class _CheckPotitionState extends State<CheckPotition> {
  MapController? _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.snapshot.data;

    final latitude = data?.location?.latitude ?? (-7.747341).toString();
    final longtitude = data?.location?.longitude ?? (110.355243).toString();
    final radius = data?.location?.radius ?? 100;

    String status = 'Cek lokasi';
    IconData iconStatus = Icons.location_pin;

    if (widget.snapshot.hasError) {
      final error = jsonDecode(jsonEncode(widget.snapshot.error));
      if ([1, 2, 3].contains(error['status'])) {
        iconStatus = Icons.location_off;
        status = error['msg'];
      } else {
        iconStatus = Icons.not_listed_location;
        status = error['msg'];
      }
    }

    if (widget.snapshot.hasData) {
      _mapController?.move(
        LatLng(double.parse(latitude), double.parse(longtitude)),
        17,
        id: 'sdsdsd',
      );
      status = 'Lokasi sesuai';
      widget.onHasData();
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(interactiveFlags: InteractiveFlag.all),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    ),
                    CircleLayer(
                      circles: <CircleMarker>[
                        CircleMarker(
                          color: primaryColor50,
                          point: LatLng(
                            double.parse(latitude),
                            double.parse(longtitude),
                          ),
                          useRadiusInMeter: true,
                          radius: radius + .0,
                        )
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(
                            double.parse(latitude),
                            double.parse(longtitude),
                          ),
                          width: 80,
                          height: 80,
                          builder: (context) => Icon(
                            Icons.home_work_outlined,
                            size: 40,
                            color: primaryColor,
                          ),
                        ),
                        Marker(
                          point: LatLng(
                            data?.current.latitude ?? double.parse(latitude),
                            data?.current.longitude ?? double.parse(longtitude),
                          ),
                          width: 80,
                          height: 80,
                          builder: (context) => Icon(
                            Icons.location_on_outlined,
                            size: 40,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Stack(
                        children: [
                          const CirclePulse(duration: 800),
                          const CirclePulse(begin: 80, end: 110, duration: 800),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                color: primaryColor,
                              ),
                              child: Icon(
                                iconStatus,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        status,
                        textAlign: TextAlign.center,
                        style: blackTextStyle.copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _mapController?.dispose();
  }
}
