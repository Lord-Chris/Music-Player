import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:musicool/app/index.dart';
import 'package:musicool/core/enums/app_player_state.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/components/_components.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';
import 'package:musicool/ui/shared/size_config.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/widget/my_botttom_sheet.dart';
import 'package:provider/provider.dart';

class MyMusicCard extends StatelessWidget {
  final Track? music;
  final String? listId;

  const MyMusicCard({
    Key? key,
    this.music,
    this.listId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Track? _track = Provider.of<Track?>(context);
    return BaseView<MusicCardModel>(
      builder: (context, model, child) {
        return InkWell(
          onTap: () => model.onTrackTap(music!, listId),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: MediaArt(
                    art: music?.artwork,
                    size: 60,
                    defArtSize: 30,
                  ),
                ),
                SizedBox(width: SizeConfig.xMargin(context, 6)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        music!.title!,
                        maxLines: 1,
                        style: kBodyStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        music!.artist!,
                        maxLines: 1,
                        style: kSubBodyStyle,
                      ),
                    ],
                  ),
                ),
                const XMargin(10),
                Text(
                  music!.toTime(),
                  style: kBodyStyle.copyWith(fontSize: 15),
                ),
                SizedBox(
                  width: SizeConfig.xMargin(context, 2),
                ),
                _track?.id == music?.id
                    ? StreamBuilder<AppPlayerState>(
                        stream: model.playerStateController.stream,
                        builder: (context, snapshot) {
                          return PlayButton(
                            size: 10,
                            showPause:
                                model.isPlaying && model.currentTrack == music,
                            onTap: () => model.onPlayTap(music!.id!),
                          );
                        },
                      )
                    : Container(),
                SizedBox(
                  width: SizeConfig.xMargin(context, 1),
                ),
                InkWell(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return MyBottomSheet(track: music);
                    },
                  ),
                  child: Icon(
                    Icons.more_horiz,
                    color: Theme.of(context).colorScheme.secondary,
                    size: SizeConfig.textSize(context, 6),
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
  final _navigationService = locator<INavigationService>();
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

  void onTrackTap(Track track, [String? id]) async {
    await _playerService.changeCurrentListOfSongs(id);
    _navigationService.toNamed(Routes.playingRoute, arguments: track);
  }

  bool get isPlaying => _appAudioService.playerState == AppPlayerState.Playing;
  StreamController<AppPlayerState> get playerStateController =>
      _appAudioService.playerStateController;
  Track? get currentTrack => _appAudioService.currentTrack;
}
