import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:musicool/app/index.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';

import 'playing_art.dart';
import 'playingmodel.dart';

class Playing extends StatelessWidget {
  final bool startPlaying;
  final Track song;
  const Playing({
    Key? key,
    required this.startPlaying, //= true,
    required this.song,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<PlayingModel>(
      onModelReady: (model) {
        model.onModelReady(song, startPlaying);
      },
      builder: (context, model, child) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              color: AppColors.white,
              child: StreamBuilder<Duration?>(
                stream: model.sliderPosition,
                builder: (context, snapshot) {
                  final currentTrack = model.current ?? song;
                  Duration data = snapshot.data ?? Duration.zero;
                  double value = data.inMilliseconds.toDouble();
                  double totalDuration =
                      model.songDuration ?? song.duration!.ceilToDouble();
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const YMargin(20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const XMargin(20),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            color: AppColors.darkMain,
                            icon: Icon(
                              MdiIcons.chevronDown,
                              size: 30.sm,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Now Playing',
                                style: kBodyStyle.copyWith(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                ),
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
                      PlayingArtView(
                        track: currentTrack,
                        list: model.songsList,
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Text(
                            model.current?.displayName ?? song.displayName!,
                            textAlign: TextAlign.center,
                            style: kSubHeadingStyle.copyWith(fontSize: 16.sp),
                          ),
                          const YMargin(10),
                          Text(
                            model.current?.artist ?? song.artist!,
                            textAlign: TextAlign.center,
                            style: kBodyStyle.copyWith(
                              fontSize: 12.sp,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const XMargin(40),
                          Expanded(
                            child: Slider(
                              value: (value / totalDuration) > 1.0
                                  ? 0
                                  : (value / totalDuration),
                              onChanged: model.setSliderPosition,
                              min: 0,
                              max: 1,
                              activeColor: AppColors.darkMain,
                              inactiveColor: AppColors.grey,
                            ),
                          ),
                          const XMargin(40),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const XMargin(60),
                          Text(
                            model.getDuration(data),
                            style: kSubBodyStyle.copyWith(
                                color: AppColors.darkMain),
                          ),
                          const Spacer(),
                          Text(
                            (currentTrack).toTime(),
                            style: kSubBodyStyle.copyWith(
                                color: AppColors.darkMain),
                          ),
                          const XMargin(60),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(flex: 2),
                          IconButton(
                            onPressed: () => model.previous(),
                            icon: Icon(
                              Icons.skip_previous,
                              color: AppColors.darkMain,
                              size: 30.sp,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () => model.onPlayButtonTap(),
                            child: Container(
                              padding: EdgeInsets.all(17.r),
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
                              child: Center(
                                child: StreamBuilder<AppPlayerState>(
                                  stream: model.playerStateStream,
                                  builder: (context, snapshot) {
                                    return Icon(
                                      model.isPlaying
                                          ? MdiIcons.pause
                                          : MdiIcons.play,
                                      key: UniqueKeys.PAUSEPLAY,
                                      color: AppColors.white,
                                      size: 30.sp,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => model.next(),
                            icon: Icon(
                              Icons.skip_next,
                              color: AppColors.darkMain,
                              size: 30.sp,
                            ),
                          ),
                          const Spacer(flex: 2),
                        ],
                      ),
                      const Spacer(flex: 2),
                      Center(
                        child: ClipPath(
                          clipper: BottomWidget(),
                          child: Container(
                            height: 55.h,
                            width: 320.w,
                            padding:
                                EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 10.h),
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
                                    size: 25.sp,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => model.toggleFav(),
                                  icon: Icon(
                                    (currentTrack).isFavorite
                                        ? MdiIcons.heart
                                        : MdiIcons.heartOutline,
                                    size: 25.sp,
                                    color: (currentTrack).isFavorite
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
                                    size: 25.sp,
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
