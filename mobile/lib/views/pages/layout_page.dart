import 'package:flutter/material.dart';
import 'package:presensi_pintar_ta/model/profile_model.dart';
import 'package:presensi_pintar_ta/provider/store_provider.dart';
import 'package:presensi_pintar_ta/provider/stream/auth_stream.dart';
import 'package:presensi_pintar_ta/services/locator/navigation_service.dart';
import 'package:presensi_pintar_ta/services/locator/locator.dart';
import 'package:presensi_pintar_ta/utils/debug_print.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:presensi_pintar_ta/views/pages/history_page.dart';
import 'package:presensi_pintar_ta/views/pages/home_page.dart';
import 'package:presensi_pintar_ta/views/pages/profile_page.dart';
import 'package:presensi_pintar_ta/views/pages/schedule_page.dart';
import 'package:presensi_pintar_ta/views/widgets/activation/activation_landing.dart';
import 'package:provider/provider.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  final navigator = locator<NavigationService>().navigator!;
  final authService = locator<AuthStream>();

  final List<Widget> _pageLists = [];
  int _bottomNavCurrentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageLists.add(const HomePage());
    _pageLists.add(const HistoryPage());
    _pageLists.add(const SchedulePage());
    _pageLists.add(const ProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<UserStore>();

    dd(store.profile?.status);

    // if user status is nonactive
    if (store.profile?.status == ProfileStatus.inactive) {
      return const ActivationLanding();
    }

    if (store.profile?.status != ProfileStatus.active) {
      return const Scaffold();
    }

    return Scaffold(
      body: _pageLists[_bottomNavCurrentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavCurrentIndex,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey.shade400,
        showUnselectedLabels: true,
        selectedItemColor: primaryColor,
        onTap: (i) {
          setState(() {
            _bottomNavCurrentIndex = i;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_sharp),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_sharp),
            label: 'Jadwal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
