import 'package:flutter/material.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';

class HeaderLabel extends StatelessWidget {
  const HeaderLabel({super.key, this.label, required this.onBackPressed});

  final String? label;
  final void Function() onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      width: double.infinity,
      height: 150,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.black, Colors.transparent],
        ),
      ),
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onBackPressed,
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  height: 50,
                  width: 50,
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Text(
                label ?? '',
                textAlign: TextAlign.center,
                style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                width: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
