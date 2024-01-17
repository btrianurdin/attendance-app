import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensi_pintar_ta/provider/store_provider.dart';
import 'package:presensi_pintar_ta/services/api/face_service.dart';
import 'package:presensi_pintar_ta/services/locator/activation_service.dart';
import 'package:presensi_pintar_ta/services/locator/navigation_service.dart';
import 'package:presensi_pintar_ta/services/api/profile_service.dart';
import 'package:presensi_pintar_ta/services/locator/locator.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:presensi_pintar_ta/views/widgets/activation/activation_landing.dart';
import 'package:presensi_pintar_ta/views/widgets/components/button.dart';
import 'package:provider/provider.dart';

class ActivationProcess extends StatefulWidget {
  const ActivationProcess({super.key});

  @override
  State<ActivationProcess> createState() => _ActivationProcessState();
}

class _ActivationProcessState extends State<ActivationProcess> {
  final _activationService = locator<ActivationService>();
  final _navigator = locator<NavigationService>().navigator!;

  final _faceService = FaceService();

  @override
  Widget build(BuildContext context) {
    final store = context.read<UserStore>();
    final profile = store.profile;

    return WillPopScope(
      onWillPop: cancelActivation,
      child: Scaffold(
        body: SafeArea(
          child: FutureBuilder(
            future: _faceService.addFaces(_activationService.faces),
            builder: (context, snapshoot) {
              if (snapshoot.connectionState == ConnectionState.done &&
                  snapshoot.hasError) {
                Fluttertoast.showToast(msg: 'Gagal memproses');
              }
              if (snapshoot.connectionState == ConnectionState.done &&
                  snapshoot.hasData) {
                Future.delayed(const Duration(seconds: 2)).then((_) {
                  store.setStatusActive();
                  _navigator.pushNamedAndRemoveUntil(
                      '/layout', (route) => false);
                });
              }
              return Container(
                padding: paddingAll,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 300,
                      width: screen(context).width,
                      child: SvgPicture.asset('assets/timeloading.svg'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: screen(context).height * 0.25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                snapshoot.connectionState ==
                                        ConnectionState.waiting
                                    ? 'Tunggu sebentar yaaa,'
                                    : snapshoot.hasData
                                        ? 'Yeahhh, Selamat, ${profile?.name}.'
                                        : 'Aduhh, maaf nih, ${profile?.name}.',
                                style: blackTextStyle.copyWith(fontSize: 18),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                snapshoot.connectionState ==
                                        ConnectionState.waiting
                                    ? 'sedang memproses aktivasi akun kamu...'
                                    : snapshoot.hasData
                                        ? 'Aktivasi akun kamu berhasil 😁'
                                        : 'Aktivasi akun kamu gagal. Coba lagi yaa.',
                                textAlign: TextAlign.center,
                                style: blackTextStyle.copyWith(fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: 150,
                            height: 100,
                            alignment: Alignment.center,
                            child: snapshoot.connectionState ==
                                    ConnectionState.waiting
                                ? const CircularProgressIndicator()
                                : snapshoot.hasError
                                    ? Button(
                                        label: 'Coba lagi',
                                        width: 200,
                                        onPressed: () {
                                          setState(() {});
                                        },
                                      )
                                    : Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(100),
                                          ),
                                          color: Colors.green.shade600,
                                        ),
                                        child: const Icon(
                                          Icons.check_rounded,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> cancelActivation() async {
    bool willLeave = false;
    // show the confirm dialog
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Batalkan aktivasi?',
          style: blackTextStyle.copyWith(fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              willLeave = true;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (ctx) => const ActivationLanding()),
                (route) => false,
              );
            },
            child: const Text('Ya'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tidak'),
          )
        ],
      ),
    );
    return willLeave;
  }

  @override
  void dispose() {
    super.dispose();
    _activationService.dispose();
  }
}
