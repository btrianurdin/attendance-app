import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:presensi_pintar_ta/provider/store_provider.dart';
import 'package:presensi_pintar_ta/services/api/leave_service.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:presensi_pintar_ta/views/widgets/components/appbarsliver.dart';
import 'package:presensi_pintar_ta/views/widgets/components/button.dart';
import 'package:provider/provider.dart';

class AddAnnualLeavePage extends StatefulWidget {
  const AddAnnualLeavePage({super.key});

  @override
  State<AddAnnualLeavePage> createState() => _AddAnnualLeavePageState();
}

class _AddAnnualLeavePageState extends State<AddAnnualLeavePage> {
  final _leaveService = LeaveService();

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
                title: 'Pengajuan Cuti',
                maxExtent: 100,
                onPressBack: () {
                  Navigator.pop(context);
                },
                bottomChild: Text(
                  'Pengajuan Cuti',
                  style: blackTextStyle.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            body: ListView(children: [
              Container(
                padding: paddingAll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Text('Tanggal', style: blackTextStyle),
                    const SizedBox(height: 15),
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
                    const SizedBox(height: 30),
                    Button(
                      label: 'Kirim Pengajuan',
                      height: 60,
                      isLoading: _isLoading,
                      isDisabled: _isLoading,
                      onPressed: () async {
                        if (selectedDates.isEmpty) {
                          setState(() {
                            _showError = true;
                          });
                          return;
                        }

                        if (selectedDates.isNotEmpty) {
                          Map<String, dynamic> data = {};

                          String dates = selectedDates
                              .map((date) => date.toString())
                              .join(',');

                          data['dates'] = dates;

                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            await _leaveService.createAnnualLeaves(data);
                            Fluttertoast.showToast(
                                msg: 'Berhasil mengajukan cuti');

                            if (mounted) {
                              Navigator.pop(context, "success");
                              context
                                  .read<UserStore>()
                                  .annualLeaves
                                  ?.isFetched = false;
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
            ]),
          ),
        ),
      ),
    );
  }

  List<Widget> _showDates() {
    List<Widget> render = selectedDates.map((date) {
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
                      DateFormat('d MMM y').format(DateTime.parse(date)),
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
