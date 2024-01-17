import 'package:flutter/material.dart';
import 'package:presensi_pintar_ta/provider/store_provider.dart';
import 'package:presensi_pintar_ta/services/api/attendance_service.dart';
import 'package:presensi_pintar_ta/utils/debug_print.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:presensi_pintar_ta/views/widgets/components/appbarsliver.dart';
import 'package:presensi_pintar_ta/views/widgets/home/attendance_box.dart';
import 'package:presensi_pintar_ta/views/widgets/home/other_menu.dart';
import 'package:presensi_pintar_ta/views/widgets/home/information.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _attendanceService = AttendanceService();

  Future<void> _fetchedAttendance() async {
    final result = await _attendanceService.today();
    if (mounted) {
      Provider.of<UserStore>(context, listen: false).setAttendance(result);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var store = context.watch<UserStore>();
    var profile = store.profile;
    bool isFetched = false;
    if (store.attendance != null) {
      isFetched = store.attendance!.isFetched;
    }

    dd(profile);

    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          AppBarSliver(
            title: 'Home',
            maxExtent: 130,
            bottomChild: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${profile?.name}',
                            style: blackTextStyle.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${profile?.position?.name}',
                            style: blackTextStyle.copyWith(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        profile?.profilePic ?? '',
                        fit: BoxFit.cover,
                        width: 70,
                        height: 70,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
        body: RefreshIndicator(
          onRefresh: _fetchedAttendance,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                FutureBuilder(
                  future: isFetched ? null : _fetchedAttendance(),
                  builder: (context, snapshot) {
                    return AttendanceBox(
                      isLoading:
                          snapshot.connectionState == ConnectionState.waiting,
                    );
                  },
                ),
                const SizedBox(height: 20),
                OtherMenu(),
                const SizedBox(height: 20),
                Information(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
