import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/ui/components/_components.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';

import 'playingmodel.dart';

class Playing extends StatelessWidget {
  final bool? play;
  final Track? song;
  const Playing({
    Key? key,
    this.play = true,
    @required this.song,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _device = MediaQuery.of(context).size;
    return BaseView<PlayingModel>(
      onModelReady: (model) {
        model.onModelReady(song!, play!);
      },
      builder: (context, model, child) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              color: AppColors.white,
              child: StreamBuilder<Duration>(
                stream: model.sliderPosition,
                builder: (context, snapshot) {
                  Duration data = snapshot.data ?? Duration.zero;
                  double value = data.inMilliseconds.toDouble();
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const YMargin(20),
                      Row(
                        children: [
                          const XMargin(20),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            color: AppColors.darkMain,
                            icon: const Icon(
                              MdiIcons.chevronDown,
                              size: 35,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Now Playing',
                                style: kBodyStyle.copyWith(fontSize: 30),
                              ),
                            ),
                          ),
                          const XMargin(70),
                        ],
                      ),
                      const Spacer(flex: 2),
                      AbsorbPointer(
                        absorbing: true,
                        child: CarouselSlider.builder(
                          options: CarouselOptions(
                            height: 450,
                            scrollDirection: Axis.horizontal,
                          ),
                          carouselController: model.controller,
                          itemCount: model.songsList.length,
                          itemBuilder: (_, index, inte) {
                            final _current = model.songsList[index];
                            return PlayingArt(art: _current.artwork);
                          },
                        ),
                      ),
                      const Spacer(),
                      Column(children: [
                        Text(
                          model.current!.title!,
                          textAlign: TextAlign.center,
                          style: kSubHeadingStyle.copyWith(fontSize: 25),
                        ),
                        const YMargin(20),
                        Text(
                          model.current!.artist!,
                          textAlign: TextAlign.center,
                          style: kSubBodyStyle.copyWith(fontSize: 20),
                        ),
                      ]),
                      const Spacer(),
                      Slider(
                        value: value,
                        onChanged: (val) => model.setSliderPosition(val),
                        max: value >= model.songDuration - 2000
                            ? model.songDuration + 500
                            : model.songDuration,
                        activeColor: AppColors.darkMain,
                        inactiveColor: AppColors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const XMargin(20),
                          Text(
                            model.getDuration(data),
                            style: kSubBodyStyle.copyWith(
                                color: AppColors.darkMain),
                          ),
                          const Spacer(),
                          Text(
                            '${model.current?.toTime()}',
                            style: kSubBodyStyle.copyWith(
                                color: AppColors.darkMain),
                          ),
                          const XMargin(20),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () => model.previous(),
                            icon: const Icon(
                              MdiIcons.rewind,
                              color: AppColors.darkMain,
                              size: 40,
                            ),
                          ),
                          InkWell(
                            onTap: () => model.onPlayButtonTap(),
                            child: Container(
                              height: 120,
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.main,
                                    AppColors.darkMain,
                                  ],
                                  stops: [0.3, 1.0],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: StreamBuilder<AppPlayerState>(
                                stream: model.playerStateStream,
                                builder: (context, snapshot) {
                                  return Icon(
                                    model.isPlaying
                                        ? MdiIcons.pause
                                        : MdiIcons.play,
                                    key: UniqueKeys.PAUSEPLAY,
                                    color: AppColors.white,
                                    size: 45,
                                  );
                                },
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => model.next(),
                            icon: const Icon(
                              MdiIcons.fastForward,
                              color: AppColors.darkMain,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 70,
                        width: MediaQuery.of(context).size.width - 70,
                        child: ClipPath(
                          clipper: BottomWidget(),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                            color: AppColors.darkMain,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () => model.toggleShuffle(),
                                  icon: Icon(
                                    MdiIcons.shuffle,
                                    color: model.shuffle
                                        ? AppColors.white
                                        : AppColors.grey,
                                    size: 30,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => model.toggleFav(),
                                  icon: Icon(
                                    model.current!.isFavorite
                                        ? MdiIcons.heart
                                        : MdiIcons.heartOutline,
                                    size: 30,
                                    color: model.current!.isFavorite
                                        ? AppColors.white
                                        : AppColors.grey,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => model.toggleRepeat(),
                                  icon: Icon(
                                    model.repeat == Repeat.One
                                        ? MdiIcons.repeatOnce
                                        : MdiIcons.repeat,
                                    color: model.repeat != Repeat.Off
                                        ? AppColors.white
                                        : AppColors.grey,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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

class BottomWidget extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path _path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.03, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.07,
        size.height * 0.05,
        size.width * 0.15,
        0,
      )
      ..lineTo(size.width * 0.85, 0)
      ..quadraticBezierTo(
        size.width * 0.93,
        size.height * 0.05,
        size.width * 0.97,
        size.height * 0.5,
      )
      ..lineTo(size.width, size.height);
    return _path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class PlayingArt extends StatelessWidget {
  final Uint8List? art;
  const PlayingArt({
    Key? key,
    required this.art,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKeys.NOWPLAYING,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      clipBehavior: Clip.hardEdge,
      height: 450,
      width: 350,
      child: Stack(
        fit: StackFit.expand,
        children: [
          MediaArt(
            art: art,
            defArtSize: 200,
          ),
          Positioned(
            top: -60,
            child: ClipOval(
              clipBehavior: Clip.hardEdge,
              child: Container(
                height: 100,
                width: 190,
                color: AppColors.white,
              ),
            ),
          ),
          Positioned(
            bottom: -75,
            left: 0,
            right: 0,
            child: Center(
              child: ClipOval(
                clipBehavior: Clip.hardEdge,
                child: Container(
                  height: 100,
                  width: 169,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
