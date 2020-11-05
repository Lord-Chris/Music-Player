import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/controls_util.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/core/view_models/base_model.dart';
import 'package:music_player/ui/base_view.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    as mi;
import 'package:music_player/ui/widget/my_botttom_sheet.dart';
import 'package:provider/provider.dart';

import '../playing.dart';

class MyMusicCard extends StatelessWidget {
  final Track music;
  final List<Track> list;

  MyMusicCard({
    Key key,
    this.music,
    this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Track _track = Provider.of<Track>(context);
    return BaseView<MusicCardModel>(
      builder: (context, model, child) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.xMargin(context, 2),
            horizontal: SizeConfig.xMargin(context, 3),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Playing(
                  songId: music.id,
                  songs: list,
                );
              }));
            },
            child: ClayContainer(
              height: SizeConfig.yMargin(context, 15),
              width: SizeConfig.xMargin(context, 100),
              borderRadius: 20,
              parentColor: Theme.of(context).shadowColor,
              color: Theme.of(context).primaryColor,
              curveType: CurveType.convex,
              // spread: ,
              child: Padding(
                padding: EdgeInsets.all(
                  SizeConfig.xMargin(context, 3),
                ),
                child: Row(
                  children: [
                    Container(
                      height: SizeConfig.xMargin(context, 17),
                      width: SizeConfig.xMargin(context, 17),
                      decoration: BoxDecoration(
                        // color: music.artWork == null ? kPrimary : null,
                        borderRadius: BorderRadius.all(
                            Radius.circular(SizeConfig.xMargin(context, 100))),
                        image: DecorationImage(
                          image: music.artWork == null
                              ? AssetImage('assets/cd-player.png')
                              : FileImage(File(music.artWork)),
                          fit: music.artWork == null
                              ? BoxFit.contain
                              : BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.xMargin(context, 6),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Spacer(),
                            Text(
                              music.title,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .color,
                                  fontSize: SizeConfig.textSize(context, 4),
                                  fontWeight: FontWeight.w400),
                            ),
                            Spacer(flex: 2),
                            Text(
                              music.artist,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .color
                                    .withOpacity(0.6),
                                fontSize: SizeConfig.textSize(context, 3),
                              ),
                            ),
                            Spacer(),
                            Text(
                              music?.toTime()?.toString() ?? '',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .color
                                    .withOpacity(0.6),
                                fontSize: SizeConfig.textSize(context, 3),
                              ),
                            ),
                            Spacer(flex: 3),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.xMargin(context, 2),
                    ),
                    _track?.id == music.id
                        ? InkWell(
                            onTap: () => model.onTap(music.id, list),
                            child: ClayContainer(
                              curveType: CurveType.convex,
                              child: Icon(
                                model.controls.state == AudioPlayerState.PLAYING
                                    ? mi.MdiIcons.pause
                                    : mi.MdiIcons.play,
                                color: Colors.white,
                                size: SizeConfig.textSize(context, 6),
                              ),
                              depth: 30,
                              color: Theme.of(context).accentColor,
                              parentColor: Theme.of(context).backgroundColor,
                              spread: 4,
// curveType: CurveType.concave,
                              height: SizeConfig.textSize(context, 8),
                              width: SizeConfig.textSize(context, 8),
                              borderRadius: MediaQuery.of(context).size.width,
                            ),
                          )
                        : Container(),
                    SizedBox(
                      width: SizeConfig.xMargin(context, 1),
                    ),
                    InkWell(
                      onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return MyBottomSheet(track: music,);
                          }),
                      child: Icon(
                        Icons.more_vert,
                        color: Theme.of(context).accentColor,
                        size: SizeConfig.textSize(context, 6),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MusicCardModel extends BaseModel {
  // AudioControls _controls = locator<AudioControls>();

  onTap(String id, [List<Track> list]) async {
    if (id != controls.nowPlaying.id) {
      if (list != null) controls.songs = list;
      controls.setIndex(id);
      controls.play();
    } else {
      controls.playAndPause();
    }
    notifyListeners();
  }

  AudioControls get controls => locator<AudioControls>();
  Track get nowPlaying => locator<SharedPrefs>().currentSong;
}
