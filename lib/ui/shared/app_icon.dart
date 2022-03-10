import 'package:flutter/material.dart';
import 'package:musicool/ui/constants/_constants.dart';

class AppIcon extends StatelessWidget {
  final double size;
  const AppIcon({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 15 + size,
      backgroundColor: AppColors.white,
      child: CircleAvatar(
        radius: 5 + size,
        backgroundColor: AppColors.lightMain,
        child: Icon(
          Icons.play_arrow_rounded,
          size: 15 + size,
          color: AppColors.white,
        ),
      ),
    );
  }
}