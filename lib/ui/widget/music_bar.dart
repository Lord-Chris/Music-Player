import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart'as player;
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/app/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/controls/new_controls_utils.dart';
import 'package:music_player/ui/constants/colors.dart';
import 'package:music_player/ui/views/base_view/base_model.dart';
import 'package:music_player/ui/views/base_view/base_view.dart';
import 'package:music_player/ui/views/playing/playing.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';
import 'package:music_player/core/utils/controls/controls_util.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    as mi;
import 'package:provider/provider.dart';

class MyMusicBar extends StatelessWidget {
  const MyMusicBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Track music = Provider.of<Track>(context);
    return BaseView<MyMusicBarModel>(
      builder: (context, model, child) {
        return music?.displayName != null
            ? InkWell(
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
                    color: Theme.of(context).backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: ThemeColors.kBlack.withOpacity(0.6),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: CircleAvatar(
                            backgroundImage: music.getArtWork() == null
                                ? AssetImage('assets/cd-player.png')
                                : FileImage(File(music.artWork)),
                            backgroundColor: Theme.of(context).backgroundColor,
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
                          padding:
                              EdgeInsets.all(SizeConfig.yMargin(context, 0.3)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Text(
                                music.title,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: SizeConfig.textSize(context, 4),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Spacer(),
                              Text(
                                music.artist,
                                maxLines: 1,
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
                                model.state == player.PlayerState.play
                                    ? mi.MdiIcons.pause
                                    : mi.MdiIcons.play,
                                color: Colors.white,
                                size: SizeConfig.textSize(context, 5.5),
                              ),
                              depth: 50,
                              color: Theme.of(context).accentColor,
                              parentColor: Theme.of(context).shadowColor,
// curveType: CurveType.concave,
                              height: SizeConfig.textSize(context, 8),
                              width: SizeConfig.textSize(context, 8),
                              borderRadius: MediaQuery.of(context).size.width,
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
  }
}

class MyMusicBarModel extends BaseModel {
  AudioControls _controls = locator<IAudioControls>();

  void onPlayButtonTap() async {
    await _controls.playAndPause();
    notifyListeners();
  }

  // onMusicSwipe() {
  //   _controls.next();
  //   notifyListeners();
  // }


  Track get nowPlaying => locator<SharedPrefs>().getCurrentSong();
  player.PlayerState get state => _controls.state;
  // Stream<Duration> get stuff => _controls.sliderPosition;
}
