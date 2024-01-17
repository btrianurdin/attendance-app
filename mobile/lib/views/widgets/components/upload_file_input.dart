import 'dart:io';

import 'package:flutter/material.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:reactive_file_picker/reactive_file_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class UploadFileInput extends StatefulWidget {
  const UploadFileInput({
    super.key,
    required this.controlName,
    this.hint,
    this.label,
    this.topLabel,
  });

  final String controlName;
  final String? hint;
  final String? label;
  final String? topLabel;

  @override
  State<UploadFileInput> createState() => _UploadFileInputState();
}

class _UploadFileInputState extends State<UploadFileInput> {
  final FocusNode _focusNode = FocusNode();

  Color _borderColor = Colors.grey.shade300;
  Color _labelColor = Colors.grey.shade500;

  List<File> selectedFile = [];

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
          child: ReactiveFilePicker<String>(
            formControlName: widget.controlName,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            filePickerBuilder: (pickImage, files, onChange) {
              if (files.platformFiles.isNotEmpty) {
                PlatformFile selectedFile = files.platformFiles.last;
                MultiFile<String> updateFile =
                    MultiFile(platformFiles: [selectedFile]);

                final form = ReactiveForm.of(context);
                if (form != null) {
                  final currentValues = form.value as Map<String, dynamic>;
                  final updatedValues = {
                    ...currentValues,
                    widget.controlName: updateFile,
                  };

                  form.updateValue(updatedValues);
                }
              }
              return TextField(
                focusNode: _focusNode,
                readOnly: true,
                onTap: () {
                  FocusScope.of(context).requestFocus(_focusNode);
                  pickImage();
                },
                controller: TextEditingController(
                    text: files.platformFiles.isNotEmpty
                        ? files.platformFiles.last.name
                        : ''),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: widget.label,
                  labelStyle: blackTextStyle.copyWith(
                    color: _labelColor,
                    fontSize: 14,
                  ),
                  hintText: widget.hint,
                  suffixIcon: const Icon(
                    Icons.upload_file,
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
