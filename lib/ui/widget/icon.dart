import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musicool/ui/constants/colors.dart';
import 'package:musicool/ui/shared/size_config.dart';

class MyIcon extends StatelessWidget {
  final bool isInverted;
  const MyIcon({
    Key? key,
    this.isInverted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClayContainer(
      borderRadius: SizeConfig.textSize(context, 1000),
      parentColor: Theme.of(context).colorScheme.secondary,
      width: SizeConfig.textSize(context, 27),
      height: SizeConfig.textSize(context, 27),
      depth: 50,
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ThemeColors.klight, width: 10),
        ),
        child: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(SizeConfig.textSize(context, 100)),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/music_logo.svg',
              height: double.maxFinite,
              width: double.maxFinite,
            ),
          ),
        ),
      ),
    );
  }
}
