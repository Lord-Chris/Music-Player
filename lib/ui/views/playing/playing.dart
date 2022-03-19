import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';

import 'playing_art.dart';
import 'playingmodel.dart';

class Playing extends StatelessWidget {
  final bool? play;
  final Track song;
  const Playing({
    Key? key,
    this.play = true,
    required this.song,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<PlayingModel>(
      onModelReady: (model) {
        model.onModelReady(song, play!);
      },
      builder: (context, model, child) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              color: AppColors.white,
              child: StreamBuilder<Duration?>(
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
                                style: kBodyStyle.copyWith(fontSize: 28),
                              ),
                            ),
                          ),
                          const XMargin(70),
                        ],
                      ),
                      const Spacer(flex: 2),
                      // AbsorbPointer(
                      //   absorbing: true,
                      //   child: CarouselSlider.builder(
                      //     options: CarouselOptions(
                      //       height: 450,
                      //       scrollDirection: Axis.horizontal,
                      //       initialPage: model.songsList.indexOf(current!),
                      //     ),
                      //     carouselController: model.controller,
                      //     itemCount: model.songsList.length,
                      //     itemBuilder: (_, index, __) {
                      //       final _current = model.songsList[index];
                      //       return PlayingArt(art: _current.artwork);
                      //     },
                      //   ),
                      // ),
                      PlayingArtView(list: model.songsList),
                      const Spacer(),
                      Column(children: [
                        Text(
                          model.current?.title ?? song.title!,
                          textAlign: TextAlign.center,
                          style: kSubHeadingStyle.copyWith(fontSize: 25),
                        ),
                        const YMargin(20),
                        Text(
                          model.current?.artist ?? song.artist!,
                          textAlign: TextAlign.center,
                          style: kSubBodyStyle.copyWith(fontSize: 20),
                        ),
                      ]),
                      const Spacer(),
                      Slider(
                        value: value / model.songDuration,
                        onChanged: model.setSliderPosition,
                        min: 0,
                        max: 1,
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
                                    (model.current ?? song).isFavorite
                                        ? MdiIcons.heart
                                        : MdiIcons.heartOutline,
                                    size: 30,
                                    color: (model.current ?? song).isFavorite
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
