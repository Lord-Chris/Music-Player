import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/ui/base_view.dart';
import 'package:music_player/ui/constants/colors.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    as mi;
import 'package:music_player/core/view_models/playingmodel.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';

class Playing extends StatelessWidget {
  final List<Track> songs;
  // final Track song;this.song,
  final int index;
  final bool play;

  Playing({Key key, this.songs, this.index, this.play = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<PlayingProvider>(
      onModelReady: (model) {
        if (songs != null) model.songs = songs;
        model.onModelReady(index,play);
      },
      // onModelFinished: (model) => model.onModelFinished(),
      builder: (context, model, child) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(20),
              color: kbgColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: ClayContainer(
                          parentColor: kbgColor,
                          color: kPrimary,
                          borderRadius: 10,
                          child: Icon(mi.MdiIcons.arrowLeft, color: kWhite),
                          height: SizeConfig.textSize(context, 10),
                          width: SizeConfig.textSize(context, 10),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Now Playing',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.textSize(context, 5),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        // color: kbgColor,
                        // borderRadius: 10,
                        // child: Icon(
                        //   mi.MdiIcons.heart,
                        //   color: model.nowPlaying.favorite
                        //       ? kPrimary
                        //       : Colors.grey[500],
                        // ),
                        height: SizeConfig.textSize(context, 9),
                        width: SizeConfig.textSize(context, 9),
                      ),
                    ],
                  ),
                  Spacer(),
                  ClayContainer(
                    depth: 50,
                    color: Colors.pinkAccent[400],
                    parentColor: kbgColor,
                    borderRadius: 20,
                    height: SizeConfig.yMargin(context, 40),
                    width: SizeConfig.xMargin(context, 60),
                    child: Container(
                      decoration: BoxDecoration(
                        color: kPrimary,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                          image: model.nowPlaying.artWork == null
                              ? AssetImage('assets/placeholder_image.png')
                              : FileImage(
                                  File(model.nowPlaying.artWork),
                                ),
                          fit: model.nowPlaying.artWork == null
                              ? BoxFit.scaleDown
                              : BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Column(children: [
                    Text(
                      model.nowPlaying.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SizeConfig.textSize(context, 5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: SizeConfig.yMargin(context, 3)),
                    Text(
                      model.nowPlaying.artist,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SizeConfig.textSize(context, 4),
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[500],
                      ),
                    ),
                  ]),
                  Spacer(),
                  StreamBuilder(
                    stream: model.sliderPosition,
                    builder: (context, snapshot) {
                      double value = snapshot.data?.inMilliseconds?.toDouble();
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(model.getDuration(duration: snapshot.data)),
                              Text(model.maxDuration),
                            ],
                          ),
                          Slider(
                            value: value ?? 0.00,
                            onChanged: (val) {
                              model.setSliderPosition(val);
                            },
                            max: value != model.songDuration - 2
                                ? model.songDuration
                                : model.songDuration + 1,
                            activeColor: kPrimary,
                            inactiveColor: Colors.white,
                          ),
                        ],
                      );
                    },
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () => model.toggleShuffle(),
                        child: ClayContainer(
                          parentColor: kbgColor,
                          color: klight,
                          child: Icon(
                            mi.MdiIcons.shuffle,
                            color: model.shuffle ? kPrimary : kWhite,
                            size: SizeConfig.textSize(context, 5),
                          ),
                          // curveType: CurveType.concave,
                          height: SizeConfig.textSize(context, 8),
                          width: SizeConfig.textSize(context, 8),
                          borderRadius: MediaQuery.of(context).size.width,
                        ),
                      ),
                      InkWell(
                        onTap: () => model.previous(),
                        child: ClayContainer(
                          parentColor: kbgColor,
                          color: klight,
                          child: Icon(
                            mi.MdiIcons.rewind,
                            color: kWhite,
                            size: SizeConfig.textSize(context, 9),
                          ),
                          // curveType: CurveType.concave,
                          height: SizeConfig.textSize(context, 14),
                          width: SizeConfig.textSize(context, 14),
                          borderRadius: MediaQuery.of(context).size.width,
                        ),
                      ),
                      InkWell(
                        onTap: () => model.onPlayButtonTap(),
                        child: ClayContainer(
                          child: Icon(
                            model.state == AudioPlayerState.PLAYING
                                ? mi.MdiIcons.pause
                                : mi.MdiIcons.play,
                            color: kWhite,
                            size: SizeConfig.textSize(context, 13),
                          ),
                          depth: 50,
                          color: kPrimary,
                          parentColor: kbgColor,
                          // curveType: CurveType.concave,
                          height: SizeConfig.textSize(context, 20),
                          width: SizeConfig.textSize(context, 20),
                          borderRadius: MediaQuery.of(context).size.width,
                        ),
                      ),
                      InkWell(
                        onTap: () => model.next(),
                        child: ClayContainer(
                          parentColor: kbgColor,
                          color: klight,
                          child: Icon(
                            mi.MdiIcons.fastForward,
                            color: kWhite,
                            size: SizeConfig.textSize(context, 9),
                          ),
                          // curveType: CurveType.concave,
                          height: SizeConfig.textSize(context, 14),
                          width: SizeConfig.textSize(context, 14),
                          borderRadius: MediaQuery.of(context).size.width,
                        ),
                      ),
                      InkWell(
                        onTap: () => model.toggleRepeat(),
                        child: ClayContainer(
                          parentColor: kbgColor,
                          color: klight,
                          child: Icon(
                            model.repeat == 'one'
                                ? mi.MdiIcons.repeatOnce
                                : mi.MdiIcons.repeat,
                            color: model.repeat == 'off' ? kWhite : kPrimary,
                            size: SizeConfig.textSize(context, 5),
                          ),
                          // curveType: CurveType.concave,
                          height: SizeConfig.textSize(context, 8),
                          width: SizeConfig.textSize(context, 8),
                          borderRadius: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
