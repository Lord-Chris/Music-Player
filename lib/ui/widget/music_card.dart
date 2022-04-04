import 'package:audio_service/audio_service.dart';
import 'package:musicool/app/index.dart';
import 'package:musicool/core/enums/app_player_state.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/components/_components.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/widget/track_detail_sheet.dart';
import 'package:provider/provider.dart';

class MyMusicCard extends StatelessWidget {
  final Track? music;
  final VoidCallback onTap;

  const MyMusicCard({
    Key? key,
    this.music,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Track? _track = Provider.of<Track?>(context);
    return BaseView<MusicCardModel>(
      builder: (context, model, child) {
        return InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: MediaArt(
                    art: music?.artwork,
                    size: 37.w,
                    defArtSize: 25.r,
                  ),
                ),
                const XMargin(15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        music!.displayName!,
                        maxLines: 1,
                        style: kBodyStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        music!.artist ?? "<unknown>",
                        maxLines: 1,
                        style: kSubBodyStyle,
                      ),
                    ],
                  ),
                ),
                const XMargin(10),
                Text(
                  music!.toTime(),
                  style: kBodyStyle.copyWith(fontSize: 11.sp),
                ),
                const XMargin(15),
                _track?.id == music?.id
                    ? StreamBuilder<AppPlayerState>(
                        stream: model.playerStateController.stream,
                        builder: (context, snapshot) {
                          return PlayButton(
                            size: 7,
                            showPause:
                                model.isPlaying && model.currentTrack == music,
                            onTap: () => model.onPlayTap(music!.id!),
                          );
                        },
                      )
                    : Container(),
                const XMargin(15),
                InkWell(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    clipBehavior: Clip.hardEdge,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(40)),
                    ),
                    builder: (_) => TrackDetailSheet(track: music!),
                  ),
                  child: Icon(
                    Icons.more_horiz,
                    color: AppColors.grey,
                    size: 25.sp,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class MusicCardModel extends BaseModel {
  final _playerService = locator<IPlayerService>();
  final _appAudioService = locator<IAppAudioService>();
  final _audioHandler = locator<AudioHandler>();

  void onPlayTap(String id) async {
    // if (id != currentTrack?.id) {
    //   // if (list != null) controls.songs = list;
    //   // controls.setIndex(id);
    // }
    if (_playerService.isPlaying) {
      await _audioHandler.pause();
    } else {
      await _audioHandler.play();
    }
    notifyListeners();
  }

  bool get isPlaying => _appAudioService.playerState == AppPlayerState.Playing;
  StreamController<AppPlayerState> get playerStateController =>
      _appAudioService.playerStateController;
  Track? get currentTrack => _appAudioService.currentTrack;
}
