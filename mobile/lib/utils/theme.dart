import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color primaryColor = const Color(0xffE31F52);
Color primaryColor50 = const Color(0x5EE31F53);
Color secondaryColor = const Color(0xff3838A8);

Color pinkColor = const Color(0xffFFA3A6);
Color orangeColor = const Color(0xffF5A629);

Color warningColor = const Color(0xffFCFAA6);
Color infoColor = const Color(0xFFA7CDEC);
Color dangerColor = const Color(0xffFFE8E8);
Color successColor = const Color(0xff1B9C85);

Color blackColor = Colors.grey.shade900;
Color backgroundColor = const Color(0xFFF5EDED);

TextStyle whiteTextStyle = GoogleFonts.poppins(
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

TextStyle blackTextStyle =
    GoogleFonts.poppins(fontWeight: FontWeight.w400, color: blackColor);

EdgeInsetsGeometry paddingHorizontal =
    const EdgeInsets.symmetric(horizontal: 16);
EdgeInsetsGeometry paddingVertical = const EdgeInsets.symmetric(vertical: 16);
EdgeInsetsGeometry paddingAll = const EdgeInsets.all(16);

Size screen(BuildContext context) {
  return MediaQuery.of(context).size;
}
