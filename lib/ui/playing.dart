import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/ui/base_view.dart';
import 'package:music_player/ui/constants/colors.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    as mi;
import 'package:music_player/core/viewmodels/playingmodel.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';

class Playing extends StatelessWidget {
  final List<SongInfo> songs;
  final SongInfo song;
  final int index;

  Playing({Key key, this.songs, this.song, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<PlayingProvider>(
      onModelReady: (model) => model.onModelReady(index),
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
                          color: kbgColor,
                          borderRadius: 10,
                          child: Icon(mi.MdiIcons.arrowLeft),
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
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      ClayContainer(
                        color: kbgColor,
                        borderRadius: 10,
                        child: Icon(
                          mi.MdiIcons.heart,
                          color: Colors.pink,
                        ),
                        height: SizeConfig.textSize(context, 10),
                        width: SizeConfig.textSize(context, 10),
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
                    child: model.nowPlaying.albumArtwork == null
                        ? Container(
                            decoration: BoxDecoration(
                              color: kPrimary,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/placeholder_image.png'),
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: kPrimary,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                image: FileImage(
                                  File(model.nowPlaying.albumArtwork),
                                ),
                                fit: BoxFit.cover,
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
                        fontSize:
                            Theme.of(context).textTheme.headline6.fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: SizeConfig.yMargin(context, 3)),
                    Text(
                      model.nowPlaying.artist,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.subtitle1.fontSize,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[500],
                      ),
                    ),
                  ]),
                  Spacer(),
                  StreamBuilder(
                    stream: model.sliderPosition,
                    builder: (context, snapshot) {
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
                            value: snapshot.data?.inMilliseconds?.toDouble() ??
                                0.00,
                            onChanged: (val) {
                              model.setSliderPosition(val);
                            },
                            max: model.songDuration,
                            activeColor: Colors.pinkAccent[400],
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
                        onTap: () => model.previous(),
                        child: ClayContainer(
                          child: Icon(
                            mi.MdiIcons.rewind,
                            color: Colors.grey[500],
                            size: 35,
                          ),
                          // curveType: CurveType.concave,
                          height: SizeConfig.textSize(context, 20),
                          width: SizeConfig.textSize(context, 20),
                          borderRadius: MediaQuery.of(context).size.width,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (model.state == AudioPlayerState.PLAYING)
                            model.pause();
                          else if (model.state == AudioPlayerState.PAUSED)
                            model.resume();
                          else if (model.state == AudioPlayerState.COMPLETED)
                            model.play();
                        },
                        child: ClayContainer(
                          child: Icon(
                            model.state == AudioPlayerState.PAUSED ||
                                    model.state == AudioPlayerState.COMPLETED
                                ? mi.MdiIcons.play
                                : mi.MdiIcons.pause,
                            color: Colors.white,
                            size: 35,
                          ),
                          depth: 50,
                          color: Colors.pinkAccent[400],
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
                          child: Icon(
                            mi.MdiIcons.fastForward,
                            color: Colors.grey[500],
                            size: 35,
                          ),
                          // curveType: CurveType.concave,
                          height: SizeConfig.textSize(context, 20),
                          width: SizeConfig.textSize(context, 20),
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
