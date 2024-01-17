import 'package:flutter/material.dart';
import 'package:presensi_pintar_ta/provider/store_provider.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:presensi_pintar_ta/views/widgets/components/appbarsliver.dart';
import 'package:presensi_pintar_ta/views/widgets/components/text_input.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EmployeeInfoPage extends StatefulWidget {
  const EmployeeInfoPage({super.key});

  @override
  State<EmployeeInfoPage> createState() => _EmployeeInfoPageState();
}

class _EmployeeInfoPageState extends State<EmployeeInfoPage> {
  final form = FormGroup({
    'division': FormControl<String>(value: ''),
    'posisition': FormControl<String>(value: ''),
    'location': FormControl<String>(value: ''),
  });

  final List<Map<String, dynamic>> personalData = [
    {'label': 'Divisi', 'controlName': 'division', 'readOnly': true},
    {'label': 'Posisi', 'controlName': 'posisition', 'readOnly': true},
    {'label': 'Lokasi', 'controlName': 'location', 'readOnly': true},
  ];

  @override
  void initState() {
    super.initState();
    _initProfile();
  }

  void _initProfile() {
    final profile = context.read<UserStore>().profile;
    if (profile != null) {
      form.control('division').updateValue(profile.position?.division?.name);
      form.control('posisition').updateValue(profile.position?.name);
      form.control('location').updateValue(profile.location?.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          AppBarSliver(
            title: 'Info Kepegawaian',
            maxExtent: 100,
            onPressBack: () {
              Navigator.pop(context);
            },
            bottomChild: Text(
              'Info Kepegawaian',
              style: blackTextStyle.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        body: ListView(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: paddingAll,
              child: ReactiveForm(
                formGroup: form,
                child: Column(
                  children: personalData.map((val) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          val['label'] ?? '',
                          style: blackTextStyle.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        TextInput(
                          controlName: val['controlName'] ?? '',
                          label: val['label'],
                          isReadOnly: val['readOnly'],
                        ),
                        const SizedBox(height: 15),
                      ],
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
