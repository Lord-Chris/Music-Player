import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/controls.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/constants/colors.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';

import '../playing.dart';

class MyMusicCard extends StatelessWidget {
  Track _nowPlaying = locator<SharedPrefs>().currentSong;
  AudioControls _controls = locator<AudioControls>();
  final Track music;
  final List<Track> list;
  MyMusicCard({
    Key key,
    this.music,
    this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.xMargin(context, 2),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Playing(index: music.index, songs: list),
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
                    borderRadius: BorderRadius.all(
                        Radius.circular(SizeConfig.xMargin(context, 100))),
                    image: DecorationImage(
                      image: music.artWork == null
                          ? AssetImage('assets/cd-player.png')
                          : FileImage(File(music.artWork)),
                      fit:
                          music.artWork == null ? BoxFit.contain : BoxFit.cover,
                    ),
                  ),
                  // child: Image(
                  //   width: SizeConfig.textSize(context, 1),
                  //   height: SizeConfig.textSize(context, 1),
                  //   image: music.artWork == null
                  //       ? AssetImage('assets/placeholder_image.png')
                  //       : FileImage(File(music.artWork)),
                  //   fit:
                  //       music.artWork == null ? BoxFit.scaleDown : BoxFit.cover,
                  // ),
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
                          music.displayName,
                          maxLines: 2,
                          style: TextStyle(
                              color: kSecondary,
                              fontSize: SizeConfig.textSize(context, 4),
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
                          music.toTime().toString(),
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
                IconButton(
                  onPressed: () {
                    _controls.index = music.index;
                    _controls.state == AudioPlayerState.PLAYING
                        ? _controls.playAndPause()
                        : _controls.play();
                  },
                  icon: Icon(
                    _nowPlaying.id == music.id &&
                            _controls.state == AudioPlayerState.PLAYING
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: kPrimary,
                    size: SizeConfig.textSize(context, 8),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
