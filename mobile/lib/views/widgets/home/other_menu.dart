import 'package:flutter/material.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';

class OtherMenu extends StatelessWidget {
  OtherMenu({super.key});

  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Ajukan Izin',
      'icon': Icon(
        Icons.work_history_outlined,
        size: 35,
        color: primaryColor,
      ),
      'bgColor': pinkColor,
      'routeName': '/leaves'
    },
    {
      'title': 'Ajukan Cuti',
      'icon': Icon(
        Icons.work_off_outlined,
        size: 35,
        color: Colors.blue.shade700,
      ),
      'bgColor': Colors.blue.shade700.withOpacity(0.3),
      'routeName': '/annualLeaves'
    },
    {
      'title': 'kelender',
      'icon': Icon(
        Icons.calendar_month_outlined,
        size: 35,
        color: Colors.orange.shade700,
      ),
      'bgColor': Colors.orange.shade700.withOpacity(0.3),
      'routeName': '/calendar'
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
            "Menu Lainnya",
            style: blackTextStyle.copyWith(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: menuItems.map((item) {
              return Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  // color: Colors.grey.shade500,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(item['routeName']);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(100)),
                            color: item['bgColor'],
                          ),
                          child: item['icon'],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['title'],
                          style: blackTextStyle.copyWith(fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
