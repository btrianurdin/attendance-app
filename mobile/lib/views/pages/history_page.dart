import 'package:flutter/material.dart';
import 'package:presensi_pintar_ta/model/attendance_model.dart';
import 'package:presensi_pintar_ta/provider/store_provider.dart';
import 'package:presensi_pintar_ta/services/api/attendance_service.dart';
import 'package:presensi_pintar_ta/utils/date_convert.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:presensi_pintar_ta/views/widgets/components/appbarsliver.dart';
import 'package:presensi_pintar_ta/views/widgets/components/empty_data.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _attendanceService = AttendanceService();

  Future<void> _fetchHistory() async {
    List result = await _attendanceService.history();
    if (mounted) {
      Provider.of<UserStore>(context, listen: false).setHistory(result);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<UserStore>();
    bool isFetched = false;
    if (store.history != null) {
      isFetched = store.history!.isFetched;
    }

    return SafeArea(
      child: FutureBuilder(
        future: isFetched ? null : _fetchHistory(),
        builder: (context, snapshoot) {
          if (snapshoot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshoot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          } else {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxScrolled) => [
                AppBarSliver(
                  title: 'Riwayat Presensi',
                  maxExtent: 100,
                  bottomChild: Text(
                    'Riwayat Presensi',
                    style: blackTextStyle.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              body: RefreshIndicator(
                onRefresh: _fetchHistory,
                child: store.history?.data == null ||
                        store.history!.data!.isEmpty
                    ? const EmptyData()
                    : ListView.builder(
                        itemCount: store.history?.data?.length ?? 0,
                        padding: paddingAll,
                        itemBuilder: (context, i) {
                          final history = store.history?.data?[i];
                          final attendanceDate = parseUtcToLocal(
                              pattern: "EEEE, dd MMMM y", date: history?.date);
                          final attendanceIn = timeParseHm(history?.checkIn);
                          final attendanceOut = timeParseHm(history?.checkOut);
                          return Container(
                            margin: EdgeInsets.only(
                                bottom: 12, top: i == 0 ? 20 : 12),
                            padding: paddingVertical,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    attendanceDate,
                                    style:
                                        blackTextStyle.copyWith(fontSize: 16),
                                  ),
                                ),
                                const Divider(height: 35),
                                Row(
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Presensi Masuk",
                                            style: blackTextStyle.copyWith(
                                                fontSize: 16),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            attendanceIn,
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
                                            "Presensi Pulang",
                                            style: blackTextStyle.copyWith(
                                                fontSize: 16),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            history?.checkIn == null
                                                ? "-"
                                                : attendanceOut,
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
                                const Divider(height: 35),
                                Padding(
                                  padding: paddingHorizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Status : ',
                                        style: blackTextStyle.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      _status(
                                        history?.status,
                                        history?.statusStr,
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Jam Kerja : ',
                                        style: blackTextStyle,
                                      ),
                                      Text(
                                        '${history?.workHour ?? '0'}',
                                        style: blackTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _status(AttendanceStatus? status, String? statusStr) {
    return Container(
      decoration: BoxDecoration(
        color: _renderColorStatus(status!),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Text(
        '$statusStr'.toUpperCase(),
        textAlign: TextAlign.start,
        style: blackTextStyle.copyWith(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }

  Color _renderColorStatus(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Colors.green.shade600;
      case AttendanceStatus.late:
        return Colors.red.shade600;
      default:
        return Colors.yellow.shade600;
    }
  }
}
