import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:musicool/core/models/_models.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';

import 'home_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      onModelReady: (model) => model.onModelReady(),
      onModelFinished: (model) => model.onModelFinished(),
      builder: (context, model, child) {
        return AppBaseView<HomeView>(
          child: Column(
            children: [
              const AppHeader(
                image: AppAssets.homeHeader,
                searchLabel: "Search song, artist or album",
              ),
              Expanded(
                child: ListView(
                  children: [
                    const YMargin(20),
                    SectionView(
                      label: "Songs",
                      items: model.musicList,
                      onTap: () => model.navigateToSongs(),
                      onItemTap: (index) => model.onSongItemTap(index),
                    ),
                    const YMargin(20),
                    SectionView(
                      label: "Artists",
                      items: model.artistList,
                      onTap: () => model.navigateToArtists(),
                      onItemTap: (index) => model.onArtistItemTap(index),
                    ),
                    const YMargin(20),
                    SectionView(
                      label: "Albums",
                      items: model.albumList,
                      onTap: () => model.navigateToAlbums(),
                      onItemTap: (index) => model.onAlbumItemTap(index),
                    ),
                    const YMargin(100),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SectionView extends StatelessWidget {
  final String label;
  final List<dynamic> items;
  final void Function()? onTap;
  final void Function(int index) onItemTap;

  const SectionView({
    Key? key,
    required this.label,
    required this.items,
    this.onTap,
    required this.onItemTap,
  })  : assert(
          items is List<Track> || items is List<Album> || items is List<Artist>,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<HomeMediainfo> _list =
        items.map((e) => HomeMediainfo.toMediaInfo(e)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: kSubHeadingStyle,
                ),
                const Text("See more >", style: kSubBodyStyle),
              ],
            ),
          ),
        ),
        const YMargin(5),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _list.length > 10 ? 10 : _list.length,
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            separatorBuilder: (__, _) => const XMargin(10),
            itemBuilder: (__, index) {
              final _item = _list[index];
              return InkWell(
                onTap: () => onItemTap(index),
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.main,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: _item.art == null
                                  ? Center(
                                      child: SvgPicture.asset(
                                        AppAssets.defaultArt,
                                        height: 70,
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  : Image.memory(
                                      _item.art!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, obj, tr) {
                                        return SvgPicture.asset(
                                          AppAssets.defaultArt,
                                          height: 70,
                                          fit: BoxFit.contain,
                                        );
                                      },
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
                              top: 15,
                              right: 15,
                              child: _item.duration != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                          child: Text(
                                            _item.duration!,
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
                      const YMargin(10),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                          _item.title ?? "",
                          style: kBodyStyle,
                          maxLines: 1,
                        ),
                      ),
                      const YMargin(5),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                          _item.subTitle!,
                          style: kSubBodyStyle,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
