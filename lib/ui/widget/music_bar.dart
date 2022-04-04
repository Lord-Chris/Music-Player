import 'package:audio_service/audio_service.dart';
import 'package:musicool/app/index.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/components/_components.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';
import 'package:musicool/ui/shared/size_config.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:provider/provider.dart';

class MusicBar extends StatelessWidget {
  const MusicBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Track? music = Provider.of<Track?>(context);
    if (music == null) return Container(height: 0);
    return BaseView<MusicBarModel>(
      builder: (context, model, child) {
        if (model.currentTrack?.filePath != null) {
          return InkWell(
            onTap: () => model.onBarTap(music),
            child: Container(
              height: 68.h,
              width: double.maxFinite,
              padding: EdgeInsets.fromLTRB(16.w, 9.h, 16.w, 9.h),
              decoration: BoxDecoration(
                color: AppColors.main,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: ThemeColors.kBlack.withOpacity(0.6),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        if (music.artwork != null)
                          BoxShadow(
                            color: const Color.fromRGBO(225, 130, 255, 0.51),
                            blurRadius: 22.r,
                            spreadRadius: 5.r,
                          ),
                      ],
                    ),
                    child: MediaArt(
                      art: music.artwork,
                      defArtSize: 46.86.r,
                      size: 50.r,
                    ),
                  ),
                  const XMargin(15),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.yMargin(context, 0.3)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Text(
                            music.displayName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kBodyStyle.copyWith(color: AppColors.white),
                          ),
                          const Spacer(),
                          Text(
                            music.artist!,
                            maxLines: 1,
                            style: kSubBodyStyle,
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: model.onPrevButtonTap,
                    iconSize: 22.sp,
                    color: AppColors.white,
                    icon: const Icon(Icons.skip_previous),
                  ),
                  const XMargin(7),
                  StreamBuilder<AppPlayerState>(
                    stream: model.playerState.stream,
                    builder: (context, snapshot) {
                      return Center(
                        child: PlayButton(
                          onTap: () => model.onPlayButtonTap(),
                          showPause:
                              model.playerStates == AppPlayerState.Playing,
                          size: 5,
                        ),
                      );
                    },
                  ),
                  const XMargin(7),
                  IconButton(
                    onPressed: model.onNextButtonTap,
                    iconSize: 22.sp,
                    color: AppColors.white,
                    icon: const Icon(Icons.skip_next),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox(height: 0, width: 0);
        }
      },
    );
  }
}

class MusicBarModel extends BaseModel {
  final _playerService = locator<IPlayerService>();
  final _appAudioService = locator<IAppAudioService>();
  final _audioHandler = locator<AudioHandler>();
  final _navigationService = locator<INavigationService>();

  void onPlayButtonTap() async {
    if (_playerService.isPlaying) {
      await _audioHandler.pause();
    } else {
      await _audioHandler.playFromMediaId(
          currentTrack!.id!, currentTrack!.toMap());
    }
    notifyListeners();
  }

  void onBarTap(Track music) {
    _navigationService.toNamed(Routes.playingRoute,
        arguments: PlayingData(music, false));
  }

  Track? get currentTrack => _appAudioService.currentTrack;
  StreamController<AppPlayerState> get playerState =>
      _appAudioService.playerStateController;
  AppPlayerState get playerStates => _appAudioService.playerState;

  Future<void> onPrevButtonTap() async {
    await _audioHandler.skipToPrevious();
  }

  Future<void> onNextButtonTap() async {
    await _audioHandler.skipToNext();
  }
}
