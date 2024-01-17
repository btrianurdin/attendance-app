import 'package:flutter/material.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';

class CirclePulse extends StatefulWidget {
  const CirclePulse({
    super.key,
    this.duration = 800,
    this.begin = 80,
    this.end = 130,
  });

  final int duration;
  final double begin;
  final double end;

  @override
  State<CirclePulse> createState() => _CirclePulseState();
}

class _CirclePulseState extends State<CirclePulse>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    )..addListener(() {
        setState(() {});
      });
    _animation =
        Tween<double>(begin: widget.begin, end: widget.end).animate(_animationController!);
    _animationController!.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: _animation!.value,
        height: _animation!.value,
        decoration: BoxDecoration(
          color: primaryColor50,
          shape: BoxShape.circle,
          // boxShadow: [
          //   BoxShadow(
          //     color: primaryColor50,
          //     spreadRadius: 5,
          //     blurRadius: 10,
          //     offset: const Offset(0, 3),
          //   )
          // ],
        ),
      ),
    );
  }
}
