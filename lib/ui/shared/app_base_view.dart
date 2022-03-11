import 'package:flutter/material.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/widget/_widgets.dart';

class AppBaseView extends StatelessWidget {
  final Widget child;
  const AppBaseView({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _device = MediaQuery.of(context).removePadding();
    return Scaffold(
      drawer: const AppDrawer(),
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
    );
  }
}
