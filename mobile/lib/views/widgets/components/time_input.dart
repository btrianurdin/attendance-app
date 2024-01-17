import 'package:flutter/material.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:reactive_forms/reactive_forms.dart';

class TimeInput extends StatefulWidget {
  const TimeInput({
    super.key,
    required this.controlName,
    this.topLabel,
    this.label,
    this.hint,
    this.timeFormat,
  });

  final String controlName;
  final String? topLabel;
  final String? label;
  final String? hint;
  final String? timeFormat;

  @override
  State<TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends State<TimeInput> {
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
          child: ReactiveTimePicker(
            formControlName: widget.controlName,
            builder: (context, picker, child) {
              return ReactiveTextField(
                focusNode: _focusNode,
                formControlName: widget.controlName,
                onTap: (control) {
                  FocusScope.of(context).requestFocus(_focusNode);
                  picker.showPicker();
                },
                readOnly: true,
                controller: TextEditingController(
                  text: picker.value != null
                      ? MaterialLocalizations.of(context).formatTimeOfDay(
                          picker.value!,
                          alwaysUse24HourFormat: true,
                        )
                      : '',
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: widget.label,
                  labelStyle:
                      blackTextStyle.copyWith(color: _labelColor, fontSize: 14),
                  hintText: widget.hint,
                  suffixIcon: const Icon(
                    Icons.access_time,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
