import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/view_models/songs_model.dart';
import 'package:music_player/ui/playing.dart';
import 'package:music_player/ui/widget/music_card.dart';

import 'base_view.dart';
import 'constants/colors.dart';
import 'shared/sizeConfig.dart';

class Songs extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return BaseView<SongsModel>(
      builder: (context, model, child) {
        return Container(
          width: SizeConfig.xMargin(context, 100),
          child: ListView.builder(
            controller: _controller,
            shrinkWrap: true,
            itemCount: model.musicList?.length ?? 0,
            itemBuilder: (__, index) {
              Track music = model.musicList[index];
              return MyMusicCard(
                music: music,
              );
            },
          ),
        );
      },
    );
  }
}

// ListView.custom(
//   controller: _controller,
//   shrinkWrap: true,
//   physics: AlwaysScrollableScrollPhysics(),
//   semanticChildCount: 3,
//   childrenDelegate: SliverChildListDelegate(
//     [
//       SizedBox(
//         height: SizeConfig.yMargin(context, 1),
//       ),
//       StreamBuilder<List<Track>>(
//         stream: model.recent().asBroadcastStream(),
//         builder: (__, snapshot) {
//           if (snapshot.data == null || snapshot.data.length < 4)
//             return Container();
//           // print(snapshot.data[0].displayName);
//           return Container(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: SizeConfig.xMargin(context, 3),
//                   ),
//                   child: Text(
//                     'Recently Played',
//                     style: TextStyle(
//                       color:
//                           Theme.of(context).textTheme.bodyText2.color,
//                       fontSize: SizeConfig.textSize(context, 5),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: SizeConfig.yMargin(context, 2),
//                 ),
//                 RecentList(snapshot: snapshot)
//               ],
//             ),
//           );
//         },
//       ),
//       ListView.builder(
//         controller: _controller,
//         shrinkWrap: true,
//         itemCount: model.musicList?.length ?? 0,
//         itemBuilder: (__, index) {
//           Track music = model.musicList[index];
//           return MyMusicCard(
//             music: music,
//           );
//         },
//       ),
//     ],
//   ),
// ),
class RecentList extends StatelessWidget {
  final AsyncSnapshot<List<Track>> snapshot;
  RecentList({
    Key key,
    this.snapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.yMargin(context, 24),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.xMargin(context, 3),
        ),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: snapshot.data.length,
        separatorBuilder: (__, index) => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.xMargin(context, 2),
          ),
        ),
        itemBuilder: (__, index) {
          Track _recent = snapshot.data[index];
          return Container(
            width: SizeConfig.xMargin(context, 31),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Playing(songId: _recent.id)),
                    );
                  },
                  child: Container(
                    width: SizeConfig.textSize(context, 27),
                    height: SizeConfig.textSize(context, 27),
                    decoration: BoxDecoration(
                      color: ThemeColors.kPrimary,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      image: DecorationImage(
                        image: _recent.artWork == null
                            ? AssetImage('assets/placeholder_image.png')
                            : FileImage(File(_recent.artWork)),
                        fit: _recent.artWork == null
                            ? BoxFit.scaleDown
                            : BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.yMargin(context, 1),
                ),
                Text(
                  _recent.displayName,
                  maxLines: 2,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText2.color,
                    fontSize: SizeConfig.textSize(context, 3.5),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.yMargin(context, 0.5),
                ),
                Text(
                  _recent.artist,
                  maxLines: 1,
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .color
                        .withOpacity(0.6),
                    fontSize: SizeConfig.textSize(context, 3.2),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
