import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presensi_pintar_ta/model/attendance_model.dart';
import 'package:presensi_pintar_ta/model/shift_model.dart';
import 'package:presensi_pintar_ta/provider/store_provider.dart';
import 'package:presensi_pintar_ta/services/locator/navigation_service.dart';
import 'package:presensi_pintar_ta/utils/date_convert.dart';
import 'package:presensi_pintar_ta/services/locator/locator.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:presensi_pintar_ta/views/widgets/components/button.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AttendanceBox extends StatelessWidget {
  AttendanceBox({super.key, this.isLoading = true});

  final bool isLoading;

  final navigator = locator<NavigationService>().navigator!;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _skeleton(context);
    }
    final attendance = context.watch<UserStore>().attendance?.data;
    final shiftIn = attendance?.shift?.checkIn;
    final shiftOut = attendance?.shift?.checkOut;

    String shift =
        "Jam kerja hari ini :  ${timeHm(shiftIn)} - ${timeHm(shiftOut)}";
    if (attendance?.shift?.type == ShiftType.offDay) {
      shift = "Jam kerja hari ini :  Hari libur";
    }

    return Container(
      margin: paddingAll,
      padding: paddingVertical,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              DateFormat('EEEE, dd MMMM yyyy', 'id').format(DateTime.now()),
              style: blackTextStyle.copyWith(fontSize: 14),
            ),
          ),
          const Divider(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Presensi Masuk",
                      style: blackTextStyle.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeParseHm(attendance?.checkIn),
                      style: blackTextStyle.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: paddingHorizontal,
                      child: Button(
                        label: 'Masuk',
                        isDisabled: attendance?.checkIn != null,
                        onPressed: () {
                          navigator.pushNamed(
                            '/presence',
                            arguments: {'type': 'in'},
                          );
                        },
                        height: 50,
                        labelFontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  children: [
                    Text(
                      "Presensi Pulang",
                      style: blackTextStyle.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeParseHm(attendance?.checkOut),
                      style: blackTextStyle.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: paddingHorizontal,
                      child: Button(
                        label: 'Pulang',
                        isDisabled: attendance?.checkOut != null,
                        onPressed: () {
                          navigator.pushNamed(
                            '/presence',
                            arguments: {'type': 'out'},
                          );
                        },
                        type: ButtonType.outline,
                        height: 50,
                        labelFontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 35),
          Padding(
            padding: paddingHorizontal,
            child: Text(
              shift,
              textAlign: TextAlign.start,
              style: blackTextStyle.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _skeleton(context) {
    return Container(
      margin: paddingHorizontal,
      padding: paddingAll,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade400,
            highlightColor: Colors.grey.shade700,
            child: Container(
              color: Colors.grey.shade50.withOpacity(0.2),
              width: screen(context).width,
              height: 20,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade400,
                    highlightColor: Colors.grey.shade700,
                    child: Container(
                      color: Colors.grey.shade50.withOpacity(0.2),
                      height: 20,
                      width: screen(context).width * 0.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade400,
                    highlightColor: Colors.grey.shade700,
                    child: Container(
                      color: Colors.grey.shade50.withOpacity(0.2),
                      width: screen(context).width * 0.4,
                      height: 50,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade400,
                    highlightColor: Colors.grey.shade700,
                    child: Container(
                      color: Colors.grey.shade50.withOpacity(0.2),
                      width: screen(context).width * 0.4,
                      height: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade400,
                    highlightColor: Colors.grey.shade700,
                    child: Container(
                      color: Colors.grey.shade50.withOpacity(0.2),
                      width: screen(context).width * 0.4,
                      height: 50,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade400,
            highlightColor: Colors.grey.shade700,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                color: Colors.grey.shade50.withOpacity(0.2),
                width: screen(context).width * 0.4,
                height: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
