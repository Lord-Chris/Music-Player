import 'dart:io';
// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/ui/constants/colors.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:music_player/ui/views/base_view/base_view.dart';
import 'package:music_player/ui/constants/unique_keys.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';

import 'playingmodel.dart';

class Playing extends StatelessWidget {
  final List<Track>? songs;
  final bool? play;
  final Track? song;

  Playing({Key? key, this.songs, this.play = true, @required this.song})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<PlayingModel>(
      onModelReady: (model) {
        model.onModelReady(song!, play!, songs);
        // model.songs =  ?? model.list;
      },
      builder: (context, model, child) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(20),
              color: Theme.of(context).backgroundColor,
              child: StreamBuilder<Duration>(
                stream: model.sliderPosition,
                builder: (context, snapshot) {
                  Duration data = snapshot.data ?? Duration.zero;
                  double value = data.inMilliseconds.toDouble();
                  // print(model.songDuration);
                  // print(value);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: ClayContainer(
                              parentColor: Theme.of(context).backgroundColor,
                              color: ThemeColors.kPrimary,
                              borderRadius: SizeConfig.textSize(context, 2),
                              child: Icon(
                                MdiIcons.arrowLeft,
                                // color: Theme.of(context).iconTheme.color,
                                size: SizeConfig.textSize(context, 6),
                              ),
                              height: SizeConfig.textSize(context, 10),
                              width: SizeConfig.textSize(context, 10),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Now Playing',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.color,
                                  fontSize: SizeConfig.textSize(context, 5),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => model.toggleFav(),
                            child: ClayContainer(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: SizeConfig.textSize(context, 2),
                              child: Icon(
                                MdiIcons.heart,
                                size: SizeConfig.textSize(context, 6),
                                color: model.checkFav()
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                              ),
                              height: SizeConfig.textSize(context, 10),
                              width: SizeConfig.textSize(context, 10),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      ClayContainer(
                        depth: 50,
                        color: Colors.pinkAccent[400],
                        parentColor: Theme.of(context).shadowColor,
                        borderRadius: 10,
                        height: SizeConfig.yMargin(context, 40),
                        width: SizeConfig.xMargin(context, 60),
                        child: Container(
                          key: UniqueKeys.NOWPLAYING,
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            // image: DecorationImage(
                            //   image: model.nowPlaying?.getArtWork() == null
                            //       ? AssetImage('assets/placeholder_image.png')
                            //       : FileImage(
                            //           File(model.nowPlaying.artWork),
                            //         ),
                            //   fit: model.nowPlaying?.getArtWork() == null
                            //       ? BoxFit.none
                            //       : BoxFit.cover,
                            // ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Column(children: [
                        Text(
                          model.current.title!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SizeConfig.textSize(context, 5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: SizeConfig.yMargin(context, 3)),
                        Text(
                          model.current.artist!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SizeConfig.textSize(context, 4),
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context)
                                .textTheme
                                .headline1
                                ?.color
                                ?.withOpacity(0.6),
                          ),
                        ),
                      ]),
                      Spacer(),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(model.getDuration(data)),
                              Text(model.current.toTime()),
                            ],
                          ),
                          Slider(
                            value: value,
                            onChanged: (val) => model.setSliderPosition(val),
                            max: value >= model.songDuration - 2000
                                ? model.songDuration + 500
                                : model.songDuration,
                            activeColor: Theme.of(context).accentColor,
                            inactiveColor: Colors.white,
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () => model.toggleShuffle(),
                            child: ClayContainer(
                              parentColor: Theme.of(context).backgroundColor,
                              color: Theme.of(context).primaryColor,
                              child: Icon(
                                MdiIcons.shuffle,
                                color: model.shuffle!
                                    ? ThemeColors.kPrimary
                                    : Theme.of(context).iconTheme.color,
                                size: SizeConfig.textSize(context, 5),
                              ),
                              curveType: CurveType.concave,
                              height: SizeConfig.textSize(context, 8),
                              width: SizeConfig.textSize(context, 8),
                              borderRadius: MediaQuery.of(context).size.width,
                            ),
                          ),
                          InkWell(
                            onTap: () => model.previous(),
                            child: ClayContainer(
                              parentColor: Theme.of(context).backgroundColor,
                              color: Theme.of(context).primaryColor,
                              child: Icon(
                                MdiIcons.rewind,
                                color: Theme.of(context).iconTheme.color,
                                size: SizeConfig.textSize(context, 9),
                              ),
                              curveType: CurveType.concave,
                              height: SizeConfig.textSize(context, 14),
                              width: SizeConfig.textSize(context, 14),
                              borderRadius: MediaQuery.of(context).size.width,
                            ),
                          ),
                          InkWell(
                            onTap: () => model.onPlayButtonTap(),
                            child: ClayContainer(
                              child: Icon(
                                model.isPlaying
                                    ? MdiIcons.pause
                                    : MdiIcons.play,
                                key: UniqueKeys.PAUSEPLAY,
                                color: Theme.of(context).iconTheme.color,
                                size: SizeConfig.textSize(context, 13),
                              ),
                              depth: 50,
                              color: Theme.of(context).accentColor,
                              parentColor: Theme.of(context).shadowColor,
                              curveType: CurveType.concave,
                              height: SizeConfig.textSize(context, 20),
                              width: SizeConfig.textSize(context, 20),
                              borderRadius: MediaQuery.of(context).size.width,
                            ),
                          ),
                          InkWell(
                            onTap: () => model.next(),
                            child: ClayContainer(
                              parentColor: Theme.of(context).backgroundColor,
                              color: Theme.of(context).primaryColor,
                              child: Icon(
                                MdiIcons.fastForward,
                                color: Theme.of(context).iconTheme.color,
                                size: SizeConfig.textSize(context, 9),
                              ),
                              curveType: CurveType.concave,
                              height: SizeConfig.textSize(context, 14),
                              width: SizeConfig.textSize(context, 14),
                              borderRadius: MediaQuery.of(context).size.width,
                            ),
                          ),
                          InkWell(
                            onTap: () => model.toggleRepeat(),
                            child: ClayContainer(
                              parentColor: Theme.of(context).backgroundColor,
                              color: Theme.of(context).primaryColor,
                              child: Icon(
                                model.repeat == 'one'
                                    ? MdiIcons.repeatOnce
                                    : MdiIcons.repeat,
                                color: model.repeat == 'off'
                                    ? Theme.of(context).iconTheme.color
                                    : ThemeColors.kPrimary,
                                size: SizeConfig.textSize(context, 5),
                              ),
                              curveType: CurveType.concave,
                              height: SizeConfig.textSize(context, 8),
                              width: SizeConfig.textSize(context, 8),
                              borderRadius: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
