import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:musicool/ui/constants/_constants.dart';

class MediaArt extends StatelessWidget {
  final Uint8List? art;
  final double borderRadius;
  final double? size;
  final double? defArtSize;
  const MediaArt({
    Key? key,
    this.art,
    this.borderRadius = 15,
    this.size,
    this.defArtSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: AppColors.main,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.hardEdge,
      child: art == null
          ? Center(
              child: SvgPicture.asset(
                AppAssets.defaultArt,
                fit: BoxFit.contain,
                height: defArtSize,
              ),
            )
          : Image.memory(
              art!,
              fit: BoxFit.cover,
              errorBuilder: (ctx, obj, tr) {
                return SvgPicture.asset(
                  AppAssets.defaultArt,
                  fit: BoxFit.contain,
                  height: defArtSize,
                );
              },
            ),
    );
  }
}
