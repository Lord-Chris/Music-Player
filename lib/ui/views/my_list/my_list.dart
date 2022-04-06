import 'dart:ui';

import 'package:flutter_svg/svg.dart';
import 'package:musicool/app/index.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/ui/components/_components.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/views/my_list/my_list_model.dart';
import 'package:musicool/ui/widget/music_card.dart';

class SongGroupList extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  final List<Track>? list;
  final dynamic songGroup;

  SongGroupList({
    Key? key,
    this.list,
    required this.songGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _isAlbum = songGroup.runtimeType == Album;

    return BaseView<SongGroupListModel>(
      builder: (context, model, child) {
        return AppBaseView(
          child: ListView(
            controller: _controller,
            children: [
              Container(
                height: 375.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: songGroup.artwork == null ? AppColors.main : null,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40.r),
                  ),
                  image: songGroup.artwork == null
                      ? const DecorationImage(
                          image: AssetImage(AppAssets.defaultArtImage),
                        )
                      : DecorationImage(
                          image: MemoryImage(songGroup.artwork),
                          fit: BoxFit.cover,
                        ),
                ),
                clipBehavior: Clip.hardEdge,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    color: AppColors.black.withOpacity(0.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.w, top: 10.h),
                          child: IconButton(
                            onPressed: () => model.navigateBack(),
                            icon: const Icon(Icons.chevron_left),
                            iconSize: 25.sp,
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: MediaArt(
                              art: songGroup.artwork,
                              defArtSize: 70.r,
                              size: 211.r,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const XMargin(30),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _isAlbum ? songGroup.title : songGroup.name,
                                    maxLines: 1,
                                    style: kSubHeadingStyle.copyWith(
                                      color: AppColors.white,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                  const YMargin(5),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppAssets.drawerSongs,
                                        height: 15.r,
                                        color: AppColors.white,
                                      ),
                                      const XMargin(7),
                                      Text(
                                        "${songGroup.numberOfSongs} song" +
                                            (songGroup.numberOfSongs! > 1
                                                ? "s"
                                                : ""),
                                        style: kSubBodyStyle.copyWith(
                                          color: AppColors.white,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            const AppIcon(size: 10),
                            const XMargin(15),
                          ],
                        ),
                        const YMargin(14),
                      ],
                    ),
                  ),
                ),
              ),
              ListView.builder(
                controller: _controller,
                shrinkWrap: true,
                itemCount: list?.length,
                padding: EdgeInsets.only(bottom: 100.h),
                itemBuilder: (__, index) {
                  Track music = list![index];
                  return MyMusicCard(
                    music: music,
                    onTap: () => model.onTrackTap(music, songGroup.id),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
