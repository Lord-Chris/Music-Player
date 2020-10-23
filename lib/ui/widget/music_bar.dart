import 'dart:io';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/view_models/base_model.dart';
import 'package:music_player/ui/base_view.dart';
import 'package:music_player/ui/constants/colors.dart';
import 'package:music_player/ui/playing.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/utils/controls.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    as mi;

class MyMusicBar extends StatelessWidget {
  const MyMusicBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<MyMusicBarModel>(
      builder: (context, model, child) {
        return StreamBuilder<Track>(
          stream: model.test(),
          builder: (context, snapshot) {
            Track music = snapshot.data;
            return music?.displayName != null
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Playing(
                                  songId: model.nowPlaying.id,
                                  play: false,
                                )),
                      );
                    },
                    child: Container(
                      height: SizeConfig.yMargin(context, 8),
                      width: SizeConfig.xMargin(context, 100),
                      decoration: BoxDecoration(
                        color: kbgColor,
                        boxShadow: [
                          BoxShadow(
                            color: kSecondary.withOpacity(0.6),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: CircleAvatar(
                                backgroundImage: music.artWork == null
                                    ? AssetImage('assets/cd-player.png')
                                    : FileImage(File(music.artWork)),
                                backgroundColor: kbgColor,
                                radius: SizeConfig.textSize(context, 5.5),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.xMargin(context, 6),
                          ),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: EdgeInsets.all(
                                  SizeConfig.yMargin(context, 0.3)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      music.title,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize:
                                            SizeConfig.textSize(context, 4),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    music.artist,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: kSecondary.withOpacity(0.6),
                                      fontSize: SizeConfig.textSize(context, 3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.xMargin(context, 6),
                          ),
                          Expanded(
                            child: Center(
                              child: InkWell(
                                onTap: () => model.onPlayButtonTap(),
                                child: ClayContainer(
                                  curveType: CurveType.convex,
                                  child: Icon(
                                    model.state == AudioPlayerState.PLAYING
                                        ? mi.MdiIcons.pause
                                        : mi.MdiIcons.play,
                                    color: Colors.white,
                                    size: SizeConfig.textSize(context, 5.5),
                                  ),
                                  depth: 50,
                                  color: kPrimary,
                                  parentColor: kbgColor,
// curveType: CurveType.concave,
                                  height: SizeConfig.textSize(context, 8),
                                  width: SizeConfig.textSize(context, 8),
                                  borderRadius:
                                      MediaQuery.of(context).size.width,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(height: 0, width: 0);
          },
        );
      },
    );
  }
}

class MyMusicBarModel extends BaseModel {
  AudioControls _controls = locator<AudioControls>();

  void onPlayButtonTap() async {
    await _controls.playAndPause();
    notifyListeners();
  }

  // onMusicSwipe() {
  //   _controls.next();
  //   notifyListeners();
  // }

  Stream<Track> test() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 500));
      yield nowPlaying;
    }
  }

  Track get nowPlaying => locator<SharedPrefs>().currentSong;
  AudioPlayerState get state => _controls.state;
  Stream<Duration> get stuff => _controls.sliderPosition;
}
