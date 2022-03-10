import 'package:flutter/material.dart';

import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';

class AppHeader extends StatelessWidget {
  final String image;
  final String searchLabel;

  const AppHeader({
    Key? key,
    required this.image,
    required this.searchLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: MediaQuery.of(context).size.width,
      child: ClipPath(
        clipper: AppHeaderContainer(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              bottom: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const YMargin(20),
                  Row(
                    children: [
                      const XMargin(10),
                      Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () => Scaffold.of(context).openDrawer(),
                            icon: Image.asset(AppImages.drawerIcon),
                          );
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              fillColor: AppColors.white.withOpacity(0.4),
                              filled: true,
                              hintText: searchLabel,
                              hintStyle: const TextStyle(
                                color: Color.fromRGBO(4, 72, 72, 0.8),
                                fontSize: 15,
                              ),
                              contentPadding: EdgeInsets.zero,
                              constraints: BoxConstraints.tight(
                                const Size.fromHeight(40),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: InputBorder.none,
                              prefixIcon: const Icon(
                                Icons.search,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const XMargin(36)
                    ],
                  ),
                  const Spacer(),
                  const AppIcon(size: 15),
                  const YMargin(20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AppHeaderContainer extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.4)
      ..lineTo(0, size.height * 0.4)
      ..moveTo(0, size.height * 0.4)
      ..quadraticBezierTo(
        size.width * 0.02,
        size.height * 0.85,
        size.width * 0.3,
        size.height * 0.93,
      )
      ..lineTo(size.width * 0.7, size.height * 0.93)
      ..quadraticBezierTo(
        size.width * 0.98,
        size.height * 0.85,
        size.width,
        size.height * 0.4,
      )
      ..moveTo(size.width * 0.3, size.height * 0.93)
      ..lineTo(size.width * 0.5, size.height)
      ..lineTo(size.width * 0.7, size.height * 0.93);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
