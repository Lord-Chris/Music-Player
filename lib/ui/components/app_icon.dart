import 'package:musicool/app/index.dart';
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
      radius: (11 + size).w,
      backgroundColor: AppColors.white,
      child: CircleAvatar(
        radius: (3.5 + size).r,
        backgroundColor: AppColors.lightMain,
        child: Icon(
          Icons.play_arrow_rounded,
          size: (11 + size).r,
          color: AppColors.white,
        ),
      ),
    );
  }
}
