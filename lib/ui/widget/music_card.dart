import 'package:audio_service/audio_service.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:musicool/app/index.dart';
import 'package:musicool/app/locator.dart';
import 'package:musicool/core/enums/app_player_state.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/components/_components.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';
import 'package:musicool/ui/shared/size_config.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    as mi;
import 'package:musicool/ui/shared/spacings.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/widget/my_botttom_sheet.dart';
import 'package:provider/provider.dart';

import '../views/playing/playing.dart';

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
    // print(music?.artworkPath);
    // print(music?.artwork);
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
                        stream: model.playerStateStream,
                        builder: (context, snapshot) {
                          return PlayButton(
                            size: 10,
                            showPause: model.isPlaying &&
                                model.currentTrack?.id == music!.id,
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
  final _controls = locator<IPlayerService>();
  final _handler = locator<AudioHandler>();
  final _navigationService = locator<INavigationService>();

  void onPlayTap(String id) async {
    if (id != _controls.getCurrentTrack()?.id) {
      // if (list != null) controls.songs = list;
      // controls.setIndex(id);
    }
    if (_controls.isPlaying) {
      await _handler.pause();
    } else {
      await _handler.play();
    }
    notifyListeners();
  }

  void onTrackTap(Track track, [String? id]) async {
    await _controls.changeCurrentListOfSongs(id);
    _navigationService.toNamed(Routes.playingRoute, arguments: track);
  }

  bool get isPlaying => _controls.isPlaying;
  Stream<AppPlayerState> get playerStateStream => _controls.playerStateStream;
  Track? get currentTrack => _controls.getCurrentTrack();
}
