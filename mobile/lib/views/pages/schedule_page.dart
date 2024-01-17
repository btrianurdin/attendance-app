import 'package:flutter/material.dart';
import 'package:presensi_pintar_ta/model/schedule_model.dart';
import 'package:presensi_pintar_ta/model/shift_model.dart';
import 'package:presensi_pintar_ta/provider/store_provider.dart';
import 'package:presensi_pintar_ta/services/api/schedule_service.dart';
import 'package:presensi_pintar_ta/utils/date_convert.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:presensi_pintar_ta/views/widgets/components/appbarsliver.dart';
import 'package:presensi_pintar_ta/views/widgets/components/empty_data.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final _scheduleService = ScheduleService();

  Future<void> _fetchSchedules() async {
    List result = await _scheduleService.schedules();
    if (mounted) {
      Provider.of<UserStore>(context, listen: false).setSchedules(result);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<UserStore>();
    bool isFetched = false;
    if (store.schedules != null) {
      isFetched = store.schedules!.isFetched;
    }

    return SafeArea(
      child: FutureBuilder(
        future: isFetched ? null : _fetchSchedules(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          } else {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxScrolled) => [
                AppBarSliver(
                  title: 'Jadwal Kerja',
                  maxExtent: 100,
                  bottomChild: Text(
                    'Jadwal Kerja',
                    style: blackTextStyle.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              body: RefreshIndicator(
                onRefresh: _fetchSchedules,
                child: store.schedules?.data == null ||
                        store.schedules!.data!.isEmpty
                    ? const EmptyData()
                    : ListView.builder(
                        itemCount: store.schedules?.data?.length,
                        padding: paddingAll,
                        itemBuilder: (context, i) {
                          final schedule = store.schedules?.data?[i];
                          return _scheduleRender(schedule!, i == 0);
                        },
                      ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _scheduleRender(ScheduleModel schedule, bool isFirstItem) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 12,
        top: isFirstItem ? 20 : 12,
      ),
      padding: paddingAll,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${schedule.dayName![0].toUpperCase()}${schedule.dayName!.substring(1)}',
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              _renderType(schedule.type!)
            ],
          ),
          const Divider(height: 25),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  children: [
                    Text(
                      'Presensi Masuk',
                      style: blackTextStyle.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeHm(schedule.checkIn),
                      style: blackTextStyle.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  children: [
                    Text(
                      'Presensi Keluar',
                      style: blackTextStyle.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeHm(schedule.checkOut),
                      style: blackTextStyle.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderType(ShiftType type) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: type == ShiftType.offDay
            ? Colors.red.shade400
            : Colors.green.shade400,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        type == ShiftType.workDay ? 'Hari Kerja' : 'Hari Libur',
        style: whiteTextStyle.copyWith(
          fontSize: 14,
        ),
      ),
    );
  }
}
