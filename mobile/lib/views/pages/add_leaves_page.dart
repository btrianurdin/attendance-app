import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:presensi_pintar_ta/provider/store_provider.dart';
import 'package:presensi_pintar_ta/services/api/leave_service.dart';
import 'package:presensi_pintar_ta/utils/debug_print.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:presensi_pintar_ta/views/widgets/components/appbarsliver.dart';
import 'package:presensi_pintar_ta/views/widgets/components/button.dart';
import 'package:presensi_pintar_ta/views/widgets/components/dropdown_input.dart';
import 'package:presensi_pintar_ta/views/widgets/components/text_input.dart';
import 'package:presensi_pintar_ta/views/widgets/components/upload_file_input.dart';
import 'package:provider/provider.dart';
import 'package:reactive_file_picker/reactive_file_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddLeavesPage extends StatefulWidget {
  const AddLeavesPage({super.key});

  @override
  State<AddLeavesPage> createState() => _AddLeavesPageState();
}

class _AddLeavesPageState extends State<AddLeavesPage> {
  final _leaveService = LeaveService();

  final form = FormGroup({
    'type': FormControl<String>(validators: [Validators.required]),
    'reason':
        FormControl<String>(value: 'tes', validators: [Validators.required]),
    'document': FormControl<MultiFile<String>>(),
  });

  bool withHour = true;

  List<String> selectedDates = [];
  bool _showError = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxScrolled) => [
              AppBarSliver(
                title: 'Pengajuan Izin',
                maxExtent: 100,
                onPressBack: () {
                  Navigator.pop(context);
                },
                bottomChild: Text(
                  'Pengajuan Izin',
                  style: blackTextStyle.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            body: ListView(children: [
              ReactiveForm(
                formGroup: form,
                child: Container(
                  padding: paddingAll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      const DropdownInput<String>(
                        controlName: 'type',
                        items: [
                          DropdownMenuItem(
                            value: 'LEAVE',
                            child: Text('Izin Umum'),
                          ),
                          DropdownMenuItem(
                            value: 'SICK_LEAVE',
                            child: Text('Izin Sakit'),
                          ),
                        ],
                        topLabel: 'Jenis Izin',
                        label: 'Pilih jenis izin',
                      ),
                      const SizedBox(height: 15),
                      Text('Tanggal', style: blackTextStyle),
                      const SizedBox(height: 15),
                      // Row(
                      //   children: [
                      //     Flexible(
                      //       child: Column(
                      //         children: [
                      //           const DateTimeInput(
                      //             controlName: 'start_date',
                      //             label: 'Tanggal',
                      //             topLabel: 'Tanggal Mulai',
                      //           ),
                      //           if (withHour)
                      //             Column(
                      //               children: const [
                      //                 SizedBox(height: 15),
                      //                 TimeInput(
                      //                   controlName: 'start_time',
                      //                   label: 'Jam',
                      //                   topLabel: 'Jam Mulai',
                      //                 ),
                      //               ],
                      //             )
                      //         ],
                      //       ),
                      //     ),
                      //     const SizedBox(width: 20),
                      //     Flexible(
                      //       child: Column(
                      //         children: [
                      //           const DateTimeInput(
                      //             controlName: 'end_date',
                      //             label: 'Tanggal',
                      //             topLabel: 'Tanggal Selesai',
                      //           ),
                      //           if (withHour)
                      //             Column(
                      //               children: const [
                      //                 SizedBox(height: 15),
                      //                 TimeInput(
                      //                   controlName: 'end_time',
                      //                   label: 'Jam',
                      //                   topLabel: 'Jam Selesai',
                      //                 ),
                      //               ],
                      //             )
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        width: double.infinity,
                        child: GridView.count(
                          crossAxisCount: 4,
                          shrinkWrap: true,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          children: _showDates(),
                        ),
                      ),
                      if (_showError)
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: Text(
                            'Tanggal tidak boleh kosong',
                            style: blackTextStyle.copyWith(
                              fontSize: 11,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      const SizedBox(height: 15),
                      const TextInput(
                        controlName: 'reason',
                        label: 'Alasan',
                        inputType: TextInputType.multiline,
                        topLabel: 'Alasan',
                        // inputType: TextInputType.multiline,
                      ),
                      const SizedBox(height: 15),
                      const UploadFileInput(
                        controlName: 'document',
                        label: 'Pilih File',
                        topLabel: 'Lampiran (opsional)',
                      ),
                      const SizedBox(height: 20),
                      Button(
                        label: 'Kirim Pengajuan',
                        height: 60,
                        isLoading: _isLoading,
                        isDisabled: _isLoading,
                        onPressed: () async {
                          form.markAllAsTouched();
                          if (selectedDates.isEmpty) {
                            setState(() {
                              _showError = true;
                            });
                            return;
                          }

                          if (form.valid) {
                            Map<String, dynamic> data = {...form.value};

                            String dates = selectedDates
                                .map((date) => date.toString())
                                .join(',');

                            data['dates'] = dates;

                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await _leaveService.createLeave(data);
                              Fluttertoast.showToast(
                                  msg: 'Berhasil mengajukan izin');

                              if (mounted) {
                                Navigator.pop(context, "success");
                                context.read<UserStore>().leaves?.isFetched =
                                    false;
                              }
                            } catch (e) {
                              Fluttertoast.showToast(msg: e.toString());
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  List<Widget> _showDates() {
    List<Widget> render = selectedDates.map((date) {
      dd(date);
      return Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        child: Container(
          width: 70,
          height: 70,
          color: primaryColor,
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topRight,
                margin: const EdgeInsets.only(top: 5, right: 5),
                child: IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: () {
                    setState(() {
                      selectedDates.remove(date);
                    });
                  },
                  iconSize: 18,
                  color: Colors.white,
                  padding: EdgeInsets.zero,
                  alignment: Alignment.topRight,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('EEE', 'id').format(DateTime.parse(date)),
                      style: whiteTextStyle.copyWith(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      DateFormat('d MMM y', 'id').format(DateTime.parse(date)),
                      style: whiteTextStyle.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

    render.add(_addDateButton());

    return render;
  }

  Widget _addDateButton() {
    return Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      child: InkWell(
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2010),
            lastDate: DateTime(DateTime.now().year + 10),
          );

          final pickedDate = picked?.toString().split(' ')[0];

          if (pickedDate != null) {
            bool check = selectedDates.contains(pickedDate);
            if (check) {
              Fluttertoast.showToast(msg: 'Tanggal sudah dipilih');
            } else {
              setState(() {
                _showError = false;
                selectedDates.add(pickedDate);
              });
            }
          }
        },
        child: SizedBox(
          width: 70,
          height: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.add),
              Text(
                'Tambah',
                style: blackTextStyle.copyWith(
                  fontSize: 10,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
