import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DateTimeInput extends StatefulWidget {
  const DateTimeInput(
      {super.key,
      required this.controlName,
      this.topLabel,
      this.label,
      this.hint,
      this.dateFormat});

  final String controlName;
  final String? topLabel;
  final String? label;
  final String? hint;
  final String? dateFormat;

  @override
  State<DateTimeInput> createState() => _DateTimeInputState();
}

class _DateTimeInputState extends State<DateTimeInput> {
  final FocusNode _focusNode = FocusNode();
  Color _borderColor = Colors.grey.shade300;
  Color _labelColor = Colors.grey.shade500;

  @override
  void initState() {
    _focusNode.addListener(() {
      setState(() {
        _borderColor =
            _focusNode.hasFocus ? primaryColor : Colors.grey.shade300;
        _labelColor = _focusNode.hasFocus ? primaryColor : Colors.grey.shade500;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.topLabel != null)
          Text(
            widget.topLabel!,
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (widget.topLabel != null) const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: _borderColor, width: 2),
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          child: ReactiveDatePicker(
            formControlName: widget.controlName,
            builder: (context, picker, child) {
              return ReactiveTextField(
                formControlName: widget.controlName,
                focusNode: _focusNode,
                onTap: (control) {
                  FocusScope.of(context).requestFocus(_focusNode);
                  picker.showPicker();
                },
                readOnly: true,
                controller: TextEditingController(
                  text: picker.value != null
                      ? DateFormat(widget.dateFormat ?? 'dd MMMM yyyy', 'id_ID')
                          .format(picker.value!)
                      : '',
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: widget.label,
                  labelStyle:
                      blackTextStyle.copyWith(color: _labelColor, fontSize: 14),
                  hintText: widget.hint,
                  suffixIcon: const Icon(
                    Icons.calendar_month,
                    color: Colors.grey,
                  ),
                ),
              );
            },
            firstDate: DateTime(2010),
            lastDate: DateTime(DateTime.now().year + 10),
          ),
        ),
      ],
    );
  }
}
