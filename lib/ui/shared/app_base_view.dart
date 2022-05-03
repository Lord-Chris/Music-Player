import 'package:musicool/app/index.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/views/songs/songs.dart';
import 'package:musicool/ui/widget/_widgets.dart';

class AppBaseView<T extends Widget> extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  const AppBaseView({
    Key? key,
    required this.child,
    this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (T is Widget) T as SongsView;
    return SafeArea(
      child: Scaffold(
        drawer: AppDrawer<T>(),
        backgroundColor: AppColors.white,
        appBar: appBar,
        body: SizedBox(
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned.fill(child: child),
              Positioned(
                bottom: 20.h,
                left: 20.w,
                right: 20.w,
                child: const MusicBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
