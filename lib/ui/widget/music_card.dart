import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/controls.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/core/view_models/base_model.dart';
import 'package:music_player/ui/base_view.dart';
import 'package:music_player/ui/constants/colors.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    as mi;

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
    return BaseView<MusicCardModel>(
      // onModelReady: (model) => model.setState(),
      builder: (context, model, child) {
        return StreamBuilder<String>(
            stream: model.musicId(),
            builder: (context, snapshot) {
              String id = snapshot.data ?? '';
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.xMargin(context, 2),
                  horizontal: SizeConfig.xMargin(context, 3),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Playing(index: music.index, songs: list),
                      ),
                    );
                  },
                  child: ClayContainer(
                    height: SizeConfig.yMargin(context, 15),
                    width: SizeConfig.xMargin(context, 100),
                    borderRadius: 20,
                    parentColor: kbgColor,
                    color: klight,
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
                              borderRadius: BorderRadius.all(Radius.circular(
                                  SizeConfig.xMargin(context, 100))),
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
                                        color: kSecondary,
                                        fontSize:
                                            SizeConfig.textSize(context, 4),
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Spacer(flex: 2),
                                  Text(
                                    music.artist,
                                    style: TextStyle(
                                      color: kSecondary.withOpacity(0.6),
                                      fontSize: SizeConfig.textSize(context, 3),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    music?.toTime()?.toString() ?? '',
                                    style: TextStyle(
                                      color: kSecondary.withOpacity(0.6),
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
                          InkWell(
                            onTap: () => model.onTap(music.index),
                            child: ClayContainer(
                              curveType: CurveType.convex,
                              child: Icon(
                                id == music.id &&
                                        model.controls.state ==
                                            AudioPlayerState.PLAYING
                                    ? mi.MdiIcons.pause
                                    : mi.MdiIcons.play,
                                color: Colors.white,
                                size: SizeConfig.textSize(context, 6),
                              ),
                              depth: 30,
                              color: kPrimary,
                              parentColor: klight,
// curveType: CurveType.concave,
                              height: SizeConfig.textSize(context, 8),
                              width: SizeConfig.textSize(context, 8),
                              borderRadius: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}

class MusicCardModel extends BaseModel {
  // AudioControls _controls = locator<AudioControls>();
  

  onTap(int index) async {
    controls.index = index;
    notifyListeners();
    if (index == controls.index) {
      controls.state == AudioPlayerState.PLAYING
          ? controls.playAndPause()
          : controls.play();
    }
  }

  Stream<String> musicId() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 500));
      yield controls.nowPlaying?.id;
    }
  }

  AudioControls get controls => locator<AudioControls>();
  Track get nowPlaying => locator<SharedPrefs>().currentSong;
}
