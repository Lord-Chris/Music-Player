import 'package:musicool/app/index.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/ui/components/_components.dart';
import 'package:musicool/ui/constants/_constants.dart';

class PlayingArtView extends StatelessWidget {
  final List<Track>? list;
  final PageController? controller;
  final void Function(int) onPageChanged;
  const PlayingArtView({
    Key? key,
    required this.list,
    required this.controller,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 321.h,
      child: PageView.builder(
        itemCount: list?.length ?? 0,
        controller: controller,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          return Center(
            child: PlayingArt(
              art: list?[index].artwork,
            ),
          );
        },
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
            borderRadius: 29.76.r,
          ),
          Positioned(
            top: -70.h,
            left: -17.w,
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
            top: 301.h,
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
// Samsung 
