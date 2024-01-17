import 'package:flutter/material.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DropdownInput<T> extends StatefulWidget {
  const DropdownInput({
    super.key,
    required this.controlName,
    this.topLabel,
    this.label,
    this.hint,
    required this.items,
  });

  final String controlName;
  final String? topLabel;
  final String? label;
  final String? hint;
  final List<DropdownMenuItem<T>> items;

  @override
  State<DropdownInput> createState() => _DropdownInputState<T>();
}

class _DropdownInputState<T> extends State<DropdownInput> {
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
          child: ReactiveDropdownField<T>(
            focusNode: _focusNode,
            style: blackTextStyle.copyWith(fontSize: 14),
            iconSize: 0,
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle:
                  blackTextStyle.copyWith(color: _labelColor, fontSize: 14),
              border: InputBorder.none,
              hintText: widget.hint,
              suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
            formControlName: 'type',
            items: widget.items as List<DropdownMenuItem<T>>,
          ),
        ),
        // Text('${widget.control.errors}')
      ],
    );
  }
}
