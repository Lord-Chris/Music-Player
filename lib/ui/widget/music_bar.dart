import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:musicool/ui/components/_components.dart';
import 'package:provider/provider.dart';

import 'package:musicool/app/locator.dart';
import 'package:musicool/core/enums/app_player_state.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';
import 'package:musicool/ui/shared/size_config.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/views/playing/playing.dart';

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
        if (model.nowPlaying?.filePath != null) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Playing(
                          song: model.nowPlaying,
                        )),
              );
            },
            child: Container(
              height: 80,
              width: double.maxFinite,
              padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
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
                  Expanded(
                    child: Center(
                      child: MediaArt(art: music.artwork, defArtSize: 30),
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.xMargin(context, 6),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.yMargin(context, 0.3)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Text(
                            music.title!,
                            maxLines: 1,
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
                  SizedBox(
                    width: SizeConfig.xMargin(context, 6),
                  ),
                  Expanded(
                    child: Center(
                      child: PlayButton(
                        onTap: () => model.onPlayButtonTap(),
                        showPause: model.isPlaying,
                        size: 7,
                      ),
                    ),
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
  final _controls = locator<IPlayerService>();
  final _handler = locator<AudioHandler>();

  void onPlayButtonTap() async {
    if (_controls.isPlaying) {
      await _handler.pause();
    } else {
      print(nowPlaying?.filePath);
      if (_controls.playerState == AppPlayerState.Idle) {
        await _handler.playFromMediaId(
            "${nowPlaying!.id}", {'path': nowPlaying!.filePath!});
      } else {
        await _handler.play();
      }
    }
    notifyListeners();
  }

  // onMusicSwipe() {
  //   _controls.next();
  //   notifyListeners();
  // }

  Track? get nowPlaying => _controls.getCurrentTrack();
  bool get isPlaying => _controls.isPlaying;
  Stream<Duration> get stuff => _controls.currentDuration;
}
