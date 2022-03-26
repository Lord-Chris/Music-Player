import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:musicool/app/index.dart';
import 'package:musicool/ui/constants/_constants.dart';

class PlayButton extends StatelessWidget {
  final bool showPause;
  final void Function() onTap;
  final double size;
  const PlayButton({
    Key? key,
    required this.showPause,
    required this.onTap,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: (10 + size).r,
        backgroundColor: AppColors.white,
        child: CircleAvatar(
          radius: (5 + size).r,
          backgroundColor: AppColors.lightMain,
          child: Icon(
            showPause ? MdiIcons.pause : MdiIcons.play,
            size: (10 + size).r,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
