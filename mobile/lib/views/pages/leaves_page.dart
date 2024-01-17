import 'package:flutter/material.dart';
import 'package:presensi_pintar_ta/model/leave_model.dart';
import 'package:presensi_pintar_ta/provider/store_provider.dart';
import 'package:presensi_pintar_ta/services/api/leave_service.dart';
import 'package:presensi_pintar_ta/utils/date_convert.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:presensi_pintar_ta/views/widgets/components/appbarsliver.dart';
import 'package:presensi_pintar_ta/views/widgets/components/empty_data.dart';
import 'package:provider/provider.dart';

class LeavesPage extends StatefulWidget {
  const LeavesPage({super.key});

  @override
  State<LeavesPage> createState() => _LeavesPageState();
}

class _LeavesPageState extends State<LeavesPage> {
  final _leaveService = LeaveService();

  Future<void> _fetchHistory() async {
    List result = await _leaveService.getLeave();
    if (mounted) {
      Provider.of<UserStore>(context, listen: false).setLeaves(result);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<UserStore>();
    bool isFetched = false;
    if (store.leaves != null) {
      isFetched = store.leaves!.isFetched;
    }

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            AppBarSliver(
              title: 'Riwayat Izin',
              maxExtent: 100,
              onPressBack: () {
                Navigator.pop(context);
              },
              bottomChild: Text(
                'Riwayat Izin',
                style: blackTextStyle.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          body: FutureBuilder(
            future: isFetched ? null : _fetchHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return RefreshIndicator(
                onRefresh: _fetchHistory,
                child: store.leaves?.data == null || store.leaves!.data!.isEmpty
                    ? const EmptyData()
                    : ListView.builder(
                        itemCount: store.leaves?.data?.length,
                        padding: paddingAll,
                        itemBuilder: (context, i) {
                          final leaves = store.leaves?.data?[i];
                          return _renderLeaves(leaves!, i == 0,
                              i == store.leaves!.data!.length - 1);
                        },
                      ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(30),
        color: primaryColor,
        child: InkWell(
          onTap: () async {
            final result = await Navigator.of(context).pushNamed('/addLeaves');
            if (result == 'success') {
              setState(() {});
            }
          },
          child: SizedBox(
            width: 120,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                Text(
                  'Tambah',
                  style: whiteTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderLeaves(LeaveModel leaves, bool isFirst, bool isLast) {
    String submissionDate = parseUtcToLocal(
      pattern: 'EEEE, d MMM y',
      date: leaves.submissionDate,
    );

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 80 : 20, top: isFirst ? 15 : 0),
      padding: paddingAll,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    submissionDate,
                    style: blackTextStyle.copyWith(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _status(leaves.type!),
                    style: blackTextStyle.copyWith(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _renderStatus(leaves.status!),
            ],
          ),
          const Divider(),
          Text(
            'Tanggal',
            style: blackTextStyle.copyWith(fontSize: 14),
          ),
          Container(
            height: 75,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: leaves.leaveDetails!.isNotEmpty
                ? ListView(
                    scrollDirection: Axis.horizontal,
                    children: leaves.leaveDetails!.map((data) {
                      return Container(
                        width: 80,
                        height: 75,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: primaryColor,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                parseUtcToLocal(
                                  pattern: 'EEE',
                                  date: data.date,
                                ),
                                style: whiteTextStyle.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                parseUtcToLocal(
                                  pattern: 'd MMM y',
                                  date: data.date,
                                ),
                                style: whiteTextStyle.copyWith(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  )
                : Container(),
          ),
          Text('${leaves.leaveDetails!.length} hari'),
          const SizedBox(height: 5),
          const Divider(),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.message_outlined, color: Colors.grey.shade800),
              const SizedBox(width: 5),
              Flexible(child: Text(leaves.reason ?? '-'))
            ],
          )
        ],
      ),
    );
  }

  String _status(LeaveType type) {
    return type == LeaveType.sick ? 'Izin Sakit' : 'Izin Umum';
  }

  Widget _renderStatus(LeaveStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: status == LeaveStatus.approved
            ? Colors.green.shade100
            : status == LeaveStatus.pending
                ? Colors.yellow.shade100
                : Colors.red.shade100,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        status == LeaveStatus.approved
            ? 'Diterima'
            : status == LeaveStatus.pending
                ? 'Menunggu'
                : 'Ditolak',
        style: blackTextStyle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: status == LeaveStatus.approved
              ? Colors.green
              : status == LeaveStatus.pending
                  ? Colors.yellow.shade900
                  : Colors.red,
        ),
      ),
    );
  }
}
