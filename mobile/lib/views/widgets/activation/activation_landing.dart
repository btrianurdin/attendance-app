import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensi_pintar_ta/provider/store_provider.dart';
import 'package:presensi_pintar_ta/provider/stream/auth_stream.dart';
import 'package:presensi_pintar_ta/services/locator/navigation_service.dart';
import 'package:presensi_pintar_ta/services/locator/locator.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presensi_pintar_ta/views/widgets/activation/activation.dart';
import 'package:presensi_pintar_ta/views/widgets/components/button.dart';
import 'package:presensi_pintar_ta/views/widgets/components/appbarsliver.dart';
import 'package:provider/provider.dart';

class ActivationLanding extends StatefulWidget {
  const ActivationLanding({super.key});

  @override
  State<ActivationLanding> createState() => _ActivationLandingState();
}

class _ActivationLandingState extends State<ActivationLanding> {
  final navigator = locator<NavigationService>().navigator!;
  final authService = locator<AuthStream>();

  bool _isProcessLogout = false;

  final stepLists = [
    "Pastikan Anda berada di tempat yang terang dan dengan pencahayaan yang baik.",
    "Klik tombol \"Mulai Aktivasi\" di bawah ini.",
    "Anda akan diarahkan ke kamera depan smartphone Anda.",
    "Ikuti petunjuk di layar untuk mengambil 3 foto selfie secara berurutan.",
    "Pastikan wajah Anda terlihat dengan jelas pada setiap foto.",
    "Setelah selesai, sistem kami akan memproses dan memverifikasi wajah Anda.",
    "Jika verifikasi berhasil, akun Anda akan diaktifkan dan Anda dapat mulai menggunakan aplikasi kami.",
  ];

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserStore>();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            AppBarSliver(
              title: 'Aktivasi Akun',
              bottomChild: Text(
                'Aktivasi Akun',
                style: blackTextStyle.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: paddingAll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: SvgPicture.asset(
                              'assets/activation.svg',
                              width: MediaQuery.of(context).size.width * 0.6,
                            ),
                          )
                        ],
                      ),
                      Text(
                        'Halo, ${profile.profile?.name}',
                        style: blackTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Aktivasi akun anda dengan melakukan swafoto/selfie untuk mendeteksi dan mengidentifikasi fitur wajah.",
                        style: blackTextStyle.copyWith(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Berikut langkah-langkah untuk melakukan aktivasi akun:',
                        style: blackTextStyle.copyWith(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 15),
                      stepListsWidget(),
                      const SizedBox(height: 15),
                      Text(
                        'Ingat, pastikan untuk mengikuti instruksi dengan seksama dan memastikan foto selfie yang diambil berkualitas baik. Hal ini akan membantu memastikan akurasi dan keamanan identifikasi wajah.',
                        style: blackTextStyle.copyWith(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 15),
                      Button(
                        label: 'Mulai Aktivasi',
                        onPressed: () {
                          navigator.push(
                            MaterialPageRoute(
                              builder: (context) => const Activation(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      Button(
                        isLoading: _isProcessLogout,
                        label: 'Logout',
                        type: ButtonType.link,
                        onPressed: () {
                          setState(() {
                            _isProcessLogout = true;
                          });
                          authService.logout().then((value) {
                            navigator.pushNamedAndRemoveUntil(
                                '/login', (route) => false);
                            setState(() {
                              _isProcessLogout = false;
                            });
                          }).catchError((err) {
                            Fluttertoast.showToast(msg: 'Failed to logout');
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget stepListsWidget() {
    return Column(
      children: stepLists.asMap().entries.map(
        (e) {
          return Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    '${e.key + 1}.',
                    style: blackTextStyle.copyWith(fontSize: 16),
                  ),
                ),
                Expanded(
                  flex: 12,
                  child: Text(
                    e.value,
                    style: blackTextStyle.copyWith(fontSize: 16),
                  ),
                )
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
