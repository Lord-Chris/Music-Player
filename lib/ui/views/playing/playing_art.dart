import 'dart:typed_data';

import 'package:musicool/app/index.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/ui/components/_components.dart';
import 'package:musicool/ui/constants/_constants.dart';

class PlayingArtView extends StatelessWidget {
  final List<Track> list;
  final Track track;
  const PlayingArtView({
    Key? key,
    required this.list,
    required this.track,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _index = !list.contains(track) ? 0 : list.indexOf(track);
    final _beforeIndex = _index - 1 < 0 ? list.length - 1 : _index - 1;
    final _afterIndex = _index + 1 == list.length ? 0 : _index + 1;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 321.h,
      child: Stack(
        children: [
          Positioned(
            left: -256.w,
            child: PlayingArt(art: list[_beforeIndex].artwork),
          ),
          Positioned(
            right: 48.w,
            left: 48.w,
            child: Center(
              child: PlayingArt(art: list[_index].artwork),
            ),
          ),
          Positioned(
            right: -256.w,
            child: PlayingArt(art: list[_afterIndex].artwork),
          ),
        ],
      ),
    );
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
        borderRadius: BorderRadius.circular(30.r),
      ),
      clipBehavior: Clip.hardEdge,
      height: 321.h,
      width: 279.w,
      child: Stack(
        fit: StackFit.expand,
        children: [
          MediaArt(
            art: art,
            defArtSize: 120.r,
          ),
          Positioned(
            top: -70.h,
            left: -31.w,
            child: ClipOval(
              clipBehavior: Clip.hardEdge,
              child: Container(
                height: 100.h,
                width: 169.w,
                color: AppColors.white,
              ),
            ),
          ),
          Positioned(
            bottom: -85.h,
            left: 0,
            right: 0,
            child: Center(
              child: ClipOval(
                clipBehavior: Clip.hardEdge,
                child: Container(
                  height: 108.h,
                  width: 135.w,
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
