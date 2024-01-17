import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:presensi_pintar_ta/views/widgets/components/button.dart';
import 'package:presensi_pintar_ta/views/widgets/components/circle_pulse.dart';

class CheckLocation extends StatefulWidget {
  const CheckLocation({
    super.key,
    required this.snapshot,
    required this.onRefresh,
    required this.onSuccess,
  });

  final AsyncSnapshot snapshot;
  final Function onRefresh;
  final Function onSuccess;

  @override
  State<CheckLocation> createState() => _CheckLocationState();
}

class _CheckLocationState extends State<CheckLocation> {
  @override
  Widget build(BuildContext context) {
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
      iconStatus = Icons.check_circle_rounded;
      status = 'Lokasi sesuai';
      widget.onSuccess();
    }

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Stack(
                    children: [
                      widget.snapshot.connectionState == ConnectionState.waiting
                          ? Stack(
                              children: const [
                                CirclePulse(duration: 800),
                                CirclePulse(begin: 80, end: 110, duration: 800),
                              ],
                            )
                          : Container(),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(100),
                            ),
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
                Text(status, style: blackTextStyle.copyWith(fontSize: 16))
              ],
            ),
          ),
          widget.snapshot.hasError
              ? Container(
                  margin:
                      const EdgeInsets.only(right: 16, left: 16, bottom: 25),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Button(
                      label: 'Refresh',
                      onPressed: () {
                        widget.onRefresh();
                      },
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
