import 'dart:typed_data';

import 'package:flutter_svg/svg.dart';
import 'package:musicool/app/index.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';

class MediaInfoCard extends StatelessWidget {
  const MediaInfoCard({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.onTap,
    this.art,
    this.duration,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final void Function() onTap;
  final Uint8List? art;
  final String? duration;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 100.w,
        height: 145.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.main,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: art == null
                          ? Center(
                              child: SvgPicture.asset(
                                AppAssets.defaultArt,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Image.memory(
                              art!,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, obj, tr) {
                                return SvgPicture.asset(
                                  AppAssets.defaultArt,
                                  fit: BoxFit.contain,
                                );
                              },
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: -5,
                    right: -5,
                    child: PlayButton(
                      size: 4,
                      onTap: () {},
                      showPause: false,
                    ),
                  ),
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: duration != null
                        ? Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 7.w, vertical: 3.h),
                              child: Center(
                                child: Text(
                                  duration!,
                                  style: kLittleStyle,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
            const YMargin(8),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 0),
              child: Text(
                title,
                style: kBodyStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const YMargin(4),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 0),
              child: Text(
                subTitle,
                style: kSubBodyStyle,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
