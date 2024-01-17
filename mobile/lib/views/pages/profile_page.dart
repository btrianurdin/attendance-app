import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensi_pintar_ta/provider/store_provider.dart';
import 'package:presensi_pintar_ta/provider/stream/auth_stream.dart';
import 'package:presensi_pintar_ta/services/locator/navigation_service.dart';
import 'package:presensi_pintar_ta/services/api/profile_service.dart';
import 'package:presensi_pintar_ta/services/locator/locator.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:presensi_pintar_ta/views/widgets/components/appbarsliver.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profileService = ProfileService();
  final authService = locator<AuthStream>();
  final navigator = locator<NavigationService>().navigator!;

  final List<Map<String, dynamic>> privateData = [
    {'title': 'Info Personal', 'icon': Icons.person, 'route': '/personal-info'},
    {
      'title': 'Info Kepegawaian',
      'icon': Icons.person_pin,
      'route': '/employee-info'
    },
    {
      'title': 'Ganti Password',
      'icon': Icons.lock_reset_rounded,
      'route': '/change-password'
    },
  ];

  final List<Map<String, dynamic>> aboutApp = [
    {'title': 'Tentang Aplikasi', 'icon': Icons.phone_android_rounded},
    {'title': 'Bantuan', 'icon': Icons.help_outline_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    var profile = context.watch<UserStore>().profile;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          AppBarSliver(
            title: 'Profil Saya',
            maxExtent: 100,
            bottomChild: Text(
              'Profil Saya',
              style: blackTextStyle.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              Container(
                padding: paddingAll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            profile?.profilePic ?? '',
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${profile?.name}",
                                style: blackTextStyle.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "${profile?.position?.name}",
                                style: blackTextStyle.copyWith(
                                    fontSize: 16, color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 50),
                    viewPrivatedata(),
                    const SizedBox(height: 20),
                    viewAboutApp(),
                    const SizedBox(height: 20),
                    viewLogout(),
                    const SizedBox(height: 15),
                  ],
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }

  viewPrivatedata() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Pribadi',
          style: blackTextStyle.copyWith(
              fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Material(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: privateData.map((data) {
              return InkWell(
                onTap: () {
                  navigator.pushNamed(data['route']);
                },
                child: Container(
                  padding: paddingAll,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(data['icon']),
                      const SizedBox(width: 8),
                      Text(
                        data['title'],
                        style: blackTextStyle.copyWith(fontSize: 16),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  viewAboutApp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tentang Aplikasi',
          style: blackTextStyle.copyWith(
              fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Material(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: aboutApp.map((data) {
              return InkWell(
                onTap: () {},
                child: Container(
                  padding: paddingAll,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(data['icon']),
                      const SizedBox(width: 8),
                      Text(
                        data['title'],
                        style: blackTextStyle.copyWith(fontSize: 16),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  viewLogout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Akun',
          style: blackTextStyle.copyWith(
              fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Material(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              authService.logout().then((value) {
                navigator.pushNamedAndRemoveUntil('/login', (route) => false);
              }).catchError((err) {
                Fluttertoast.showToast(msg: 'Failed to logout');
              });
            },
            child: Container(
              padding: paddingAll,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.logout),
                  const SizedBox(width: 8),
                  Text(
                    'Keluar',
                    style: blackTextStyle.copyWith(fontSize: 16),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
