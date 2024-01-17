import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensi_pintar_ta/provider/store_provider.dart';
import 'package:presensi_pintar_ta/services/api/profile_service.dart';
import 'package:presensi_pintar_ta/services/locator/navigation_service.dart';
import 'package:presensi_pintar_ta/services/locator/locator.dart';
import 'package:provider/provider.dart' as p;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _profileService = ProfileService();
  final navigator = locator<NavigationService>().navigator!;

  @override
  void initState() {
    super.initState();

    checkAuth();
  }

  checkAuth() async {
    try {
      final profile = await _profileService.profile();
      if (mounted) {
        context.read<UserStore>().setProfile(profile);
        navigator.pushNamedAndRemoveUntil('/layout', (route) => false);
      }
    } on DioError {
      Fluttertoast.showToast(msg: 'Failed while connect to server!');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Server not reachable!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
