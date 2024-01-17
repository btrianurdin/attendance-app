import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class Information extends StatelessWidget {
  Information({super.key});

  final List<Map<String, String>> informationItems = [
    {
      "title": "Pengumuman Cuti Lebaran",
      "description":
          "Cuti bersama Lebaran 2023 berlaku mulai 19 April 2023 dan berakhir 25 April 2023. Dengan demikian, masyarakat sudah bisa mulai masuk bekerja pada 26 April 2023",
      "link":
          "https://www.cnbcindonesia.com/news/20230424174229-4-432047/jangan-sampai-bablas-cuti-bersama-lebaran-usai-tanggal-ini",
      "date": "Rabu, 26 Apr 2023"
    },
    {
      "title":
          "Polda Jabar pantau arus mudik dan balik Lebaran lancar kecuali Puncak",
      "description":
          "Kepolisian Daerah Jawa Barat (Polda Jabar) memantau secara keseluruhan arus mudik dan balik hingga H+4 Lebaran 2023 ini tidak ada kemacetan berarti",
      "link":
          "https://www.antaranews.com/berita/3507363/polda-jabar-pantau-arus-mudik-dan-balik-lebaran-lancar-kecuali-puncak",
      "date": "Rabu, 27 Apr 2023"
    },
    {
      "title": "Jadwal Satu Arah Jalan Tol Trans Jawa Arus Balik Lebaran 2023",
      "description":
          "Para pemudik perlu tahu jadwal satu arah jalan Tol Trans Jawa arus balik Lebaran 2023. Sebab, skema tersebut berlaku pada jam-jam tertentu",
      "link":
          "https://www.cnnindonesia.com/nasional/20230417170824-25-938918/jadwal-satu-arah-jalan-tol-trans-jawa-arus-balik-lebaran-2023",
      "date": "Rabu, 26 Apr 2023"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: paddingAll,
          child: Text(
            "Informasi",
            style: blackTextStyle.copyWith(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Padding(
          padding: paddingHorizontal,
          child: Material(
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: informationItems.map((item) {
                return InkWell(
                  onTap: () async {
                    final url = Uri.parse(item['link']!);
                    try {
                      await launchUrl(url);
                    } catch (e) {
                      Fluttertoast.showToast(msg: 'Link error');
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: paddingAll,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] ?? '',
                          style: blackTextStyle.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item['description'] ?? '',
                          textAlign: TextAlign.justify,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: blackTextStyle.copyWith(
                              fontSize: 14, color: Colors.grey.shade800),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              item['date'] ?? '',
                              style: blackTextStyle.copyWith(
                                  color: Colors.grey.shade500, fontSize: 12),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }
}
