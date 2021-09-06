import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/ui/constants/colors.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';

class MyIcon extends StatelessWidget {
  final bool isInverted;
  const MyIcon({
    Key? key,
    this.isInverted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClayContainer(
      borderRadius: SizeConfig.textSize(context, 100),
      parentColor: Theme.of(context).accentColor,
      width: SizeConfig.textSize(context, 30),
      depth: 50,
      child: Container(
        height: SizeConfig.textSize(context, 30),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ThemeColors.klight, width: 10),
        ),
        child: Container(
          width: SizeConfig.textSize(context, 30),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(SizeConfig.textSize(context, 100)),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/music_logo.svg',
              height: SizeConfig.textSize(context, 30),
            ),
          ),
        ),
      ),
    );
  }
}
