import 'package:flutter/material.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:reactive_forms/reactive_forms.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    super.key,
    required this.controlName,
    this.hint,
    this.label,
    this.topLabel,
    this.isPassword = false,
    this.inputType = TextInputType.text,
    this.isReadOnly = false,
  });

  final String controlName;
  final String? hint;
  final String? label;
  final String? topLabel;
  final bool isPassword;
  final TextInputType? inputType;
  final bool isReadOnly;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
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
          height: widget.inputType == TextInputType.multiline ? 120 : 60,
          decoration: BoxDecoration(
            border: Border.all(color: _borderColor, width: 2),
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          child: ReactiveTextField(
            formControlName: widget.controlName,
            keyboardType: widget.inputType,
            maxLines: widget.inputType == TextInputType.multiline ? null : 1,
            expands: widget.inputType == TextInputType.multiline,
            readOnly: widget.isReadOnly,
            decoration: InputDecoration(
              labelText: widget.label,
              alignLabelWithHint: widget.inputType == TextInputType.multiline,
              labelStyle:
                  blackTextStyle.copyWith(color: _labelColor, fontSize: 14),
              border: InputBorder.none,
              hintText: widget.hint,
            ),
            obscureText: widget.isPassword,
            focusNode: _focusNode,
            style: blackTextStyle.copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
