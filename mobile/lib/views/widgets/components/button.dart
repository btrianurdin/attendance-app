import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';

enum ButtonColor { primary, success, pink, orange }

enum ButtonType { contained, outline, link }

Map<ButtonColor, Color> btnColor = {
  ButtonColor.primary: primaryColor,
  ButtonColor.pink: pinkColor,
  ButtonColor.success: successColor,
  ButtonColor.orange: orangeColor,
};

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.label,
    required this.onPressed,
    this.width,
    this.height,
    this.isDisabled = false,
    this.isLoading = false,
    this.startIcon,
    this.endIcon,
    this.labelFontSize = 16,
    this.color = ButtonColor.primary,
    this.type = ButtonType.contained,
  });

  final String label;
  final void Function() onPressed;
  final double? width;
  final double? height;
  final Icon? startIcon;
  final Icon? endIcon;
  final bool isDisabled;
  final bool isLoading;
  final ButtonColor? color;
  final ButtonType? type;
  final double labelFontSize;

  @override
  Widget build(BuildContext context) {
    var bgColor = btnColor[color];
    var textColor = Colors.white;
    var borderColor = btnColor[color];

    if (isDisabled || isLoading) {
      bgColor = borderColor = pinkColor;
    }

    if (type == ButtonType.outline) {
      bgColor = Colors.transparent;
      textColor = btnColor[color]!;
      borderColor = btnColor[color]!;
      if (isDisabled || isLoading) {
        bgColor = Colors.transparent;
        textColor = Colors.grey.shade600;
        borderColor = Colors.grey.shade400;
      }
    }
    if (type == ButtonType.link) {
      bgColor = Colors.transparent;
      textColor = btnColor[color]!;
      borderColor = Colors.transparent;
      if (isDisabled || isLoading) {
        bgColor = Colors.transparent;
        textColor = Colors.grey.shade600;
        borderColor = Colors.transparent;
      }
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 55,
      child: ElevatedButton(
        onPressed: (isLoading || isDisabled) ? () {} : onPressed,
        style: ElevatedButton.styleFrom(
          side: BorderSide(color: borderColor!, width: 2),
          padding: const EdgeInsets.all(14),
          backgroundColor: bgColor,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            startIcon ?? const SizedBox(),
            SizedBox(width: startIcon != null ? 2 : 0),
            isLoading
                ? _spinnerLoading(textColor)
                : Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: labelFontSize,
                      color: textColor,
                    ),
                  ),
            SizedBox(width: endIcon != null ? 2 : 0),
            endIcon ?? const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _spinnerLoading(Color color) {
    return SizedBox(
      width: 16,
      height: 16,
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: 3,
      ),
    );
  }
}
