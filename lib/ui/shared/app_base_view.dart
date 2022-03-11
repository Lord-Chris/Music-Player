import 'package:flutter/material.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/views/songs/songs.dart';
import 'package:musicool/ui/widget/_widgets.dart';

class AppBaseView<T extends Widget> extends StatelessWidget {
  final Widget child;
  const AppBaseView({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (T is Widget) T as Songs;
    final _device = MediaQuery.of(context).removePadding();
    return SafeArea(
      child: Scaffold(
        drawer: AppDrawer<T>(),
        backgroundColor: AppColors.white,
        body: SizedBox(
          height: _device.size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned.fill(child: child),
              const Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: MusicBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
