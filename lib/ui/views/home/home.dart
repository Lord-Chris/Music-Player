import 'package:flutter/material.dart';

import 'package:musicool/core/models/_models.dart';
import 'package:musicool/ui/components/_components.dart';
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
              AppHeader(
                image: AppAssets.homeHeader,
                searchLabel: "Search song, artist or album",
                onFieldTap: model.onSearchTap,
              ),
              Expanded(
                child: ListView(
                  children: [
                    const YMargin(20),
                    SectionView(
                      label: "Songs",
                      items: model.trackList,
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
              return MediaInfoCard(
                onTap: () => onItemTap(index),
                title: _item.title!,
                subTitle: _item.subTitle!,
                art: _item.art,
                duration: _item.duration,
              );
            },
          ),
        ),
      ],
    );
  }
}
