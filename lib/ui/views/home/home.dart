import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';
import 'package:musicool/ui/shared/size_config.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/views/my_drawer/my_drawer.dart';
import 'package:musicool/ui/views/search/search.dart';
import 'package:musicool/ui/views/songs/songs.dart';
import 'package:musicool/ui/widget/music_bar.dart';

import 'home_model.dart';

// class Home extends StatelessWidget {
//   final List<Widget> tabs = [Songs(), const Artists(), const Albums()];
//   final List<String> tabsName = ['Songs', 'Artists', 'Albums'];

//   Home({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return BaseView<HomeModel>(
//       onModelReady: (model) => model.onModelReady(),
//       onModelFinished: (model) => model.onModelFinished(),
//       builder: (context, model, child) {
//         return DefaultTabController(
//           length: tabsName.length,
//           child: Scaffold(
//             appBar: AppBar(
//               toolbarHeight: 130,
//               backgroundColor: Theme.of(context).backgroundColor,
//               leading: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Builder(
//                     builder: (context) {
//                       return InkWell(
//                         onTap: () => Scaffold.of(context).openDrawer(),
//                         child: ClayContainer(
//                           parentColor: Theme.of(context).backgroundColor,
//                           color: Theme.of(context).backgroundColor,
//                           borderRadius: 10,
//                           child: Icon(
//                             mi.MdiIcons.menu,
//                             color: Theme.of(context).colorScheme.secondary,
//                             size: 30,
//                           ),
//                           height: 50,
//                           width: 50,
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               leadingWidth: SizeConfig.textSize(context, 12),
//               actions: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.push(context,
//                             MaterialPageRoute(builder: (context) => Search()));
//                       },
//                       child: ClayContainer(
//                         color: Theme.of(context).backgroundColor,
//                         borderRadius: 10,
//                         child: Icon(
//                           mi.MdiIcons.magnify,
//                           color: Theme.of(context).colorScheme.secondary,
//                           size: 30,
//                         ),
//                         height: 50,
//                         width: 50,
//                       ),
//                     ),
//                     SizedBox(width: SizeConfig.xMargin(context, 2)),
//                   ],
//                 ),
//               ],
//               bottom: TabBar(
//                 indicatorSize: TabBarIndicatorSize.label,
//                 tabs: tabsName.map((name) => Text(name)).toList(),
//                 indicatorWeight: SizeConfig.yMargin(context, 0.3),
//                 indicatorColor: ThemeColors.kPrimary,
//                 labelPadding: EdgeInsets.symmetric(
//                     vertical: SizeConfig.yMargin(context, 1)),
//                 labelColor: Theme.of(context).textTheme.bodyText2?.color,
//                 labelStyle: TextStyle(
//                   fontSize: SizeConfig.textSize(context, 5),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             drawer: const MyDrawer(),
//             body: Container(
//               key: UniqueKeys.HOMECONTAINER,
//               color: Theme.of(context).backgroundColor,
//               child: TabBarView(
//                 children: tabs.map((tab) => tab).toList(),
//               ),
//             ),
//             bottomNavigationBar: const MyMusicBar(),
//           ),
//         );
//       },
//     );
//   }
// }

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      onModelReady: (model) => model.onModelReady(),
      onModelFinished: (model) => model.onModelFinished(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: ListView(
            children: [
              const AppHeader(
                image: AppImages.homeHeader,
                searchLabel: "Search song, artist or album",
              ),
              const YMargin(20),
              SectionView(
                label: "Songs",
                titles: model.musicList
                    .map((e) => e.displayName ?? e.title)
                    .toList(),
                arts: model.musicList.map((e) => e.artwork).toList(),
                subTitle: model.musicList.map((e) => e.artist).toList(),
                duration: model.musicList.map((e) => e.toTime()).toList(),
              ),
              const YMargin(20),
              SectionView(
                label: "Artists",
                titles: model.artistList.map((e) => e.name).toList(),
                arts: model.artistList.map((e) => e.artwork).toList(),
                subTitle: model.artistList
                    .map((e) => "${e.numberOfSongs} songs")
                    .toList(),
              ),
              const YMargin(20),
              SectionView(
                label: "Albums",
                titles: model.albumList.map((e) => e.title).toList(),
                arts: model.albumList.map((e) => e.artwork).toList(),
                subTitle: model.albumList
                    .map((e) => "${e.numberOfSongs} songs")
                    .toList(),
              ),
              const YMargin(20),
            ],
          ),
        );
      },
    );
  }
}

class SectionView extends StatelessWidget {
  final String label;
  final List<Uint8List?> arts;
  final List<String?> titles;
  final List<String?> subTitle;
  final List<String?>? duration;

  const SectionView({
    Key? key,
    required this.label,
    required this.arts,
    required this.titles,
    required this.subTitle,
    this.duration,
  })  : assert(
          arts.length == titles.length && titles.length == subTitle.length,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Text(
            label,
            style: kSubHeadingStyle,
          ),
        ),
        const YMargin(5),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: arts.length,
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            separatorBuilder: (__, _) => const XMargin(10),
            itemBuilder: (__, index) {
              return SizedBox(
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
                            child: arts[index] == null
                                ? Center(
                                    child: Image.asset(
                                      AppImages.defaultArt,
                                      height: 70,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : Image.memory(
                                    arts[index]!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, obj, tr) {
                                      return Image.asset(
                                        AppImages.defaultArt,
                                        height: 70,
                                        fit: BoxFit.contain,
                                      );
                                    },
                                  ),
                          ),
                          const Positioned(
                            bottom: -5,
                            right: -5,
                            child: AppIcon(size: 7),
                          ),
                          Positioned(
                            top: 15,
                            right: 15,
                            child: duration != null
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                        child: Text(
                                          duration![index]!,
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
                        titles[index] ?? "",
                        style: kBodyStyle,
                        maxLines: 1,
                      ),
                    ),
                    const YMargin(5),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Text(
                        subTitle[index] ?? "",
                        style: kSubBodyStyle,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
