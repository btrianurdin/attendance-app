import 'package:flutter/material.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';

class AppBarSliver extends StatelessWidget {
  const AppBarSliver({
    super.key,
    required this.title,
    this.bottomChild,
    this.onPressBack,
    this.maxExtent,
    this.action,
  });

  final String title;
  final Widget? bottomChild;
  final Function()? onPressBack;
  final double? maxExtent;
  final List<Widget>? action;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverDelegate(
        title: title,
        bottomChild: bottomChild,
        onPressBack: onPressBack,
        extent: maxExtent,
        action: action,
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  SliverDelegate({
    required this.title,
    this.bottomChild,
    this.onPressBack,
    this.extent,
    this.action,
  });

  final String title;
  final Widget? bottomChild;
  final Function()? onPressBack;
  final double? extent;
  final List<Widget>? action;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = shrinkOffset / maxExtent;

    return Container(
      decoration: BoxDecoration(
        boxShadow: progress > 0.6
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ]
            : [],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppBar(
            leading: onPressBack == null
                ? Container()
                : BackButton(
                    onPressed: onPressBack,
                    color: blackColor,
                  ),
            title: Text(progress > 0.6 ? title : ''),
            centerTitle: true,
            titleTextStyle: blackTextStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            elevation: 0,
            actions: action,
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 50),
            opacity:
                progress > 0.6 ? 0 : ((progress < 0.1) ? 1 : 0.9 - progress),
            child: progress < 0.7
                ? Container(
                    alignment: Alignment.bottomLeft,
                    padding: paddingHorizontal,
                    child: bottomChild != null
                        ? SingleChildScrollView(
                            child: bottomChild,
                          )
                        : Container(),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => extent ?? 120;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
