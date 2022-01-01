import 'package:audio_service/audio_service.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:musicool/app/locator.dart';
import 'package:musicool/core/enums/app_player_state.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/core/services/player_controls/player_controls.dart';
import 'package:musicool/ui/constants/colors.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/views/playing/playing.dart';
import 'package:musicool/ui/shared/sizeConfig.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    as mi;
import 'package:provider/provider.dart';

class MyMusicBar extends StatelessWidget {
  const MyMusicBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Track? music = Provider.of<Track?>(context);
    if (music == null) return Container(height: 0);
    return BaseView<MyMusicBarModel>(
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
              height: SizeConfig.yMargin(context, 8),
              width: SizeConfig.xMargin(context, 100),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: ThemeColors.kBlack.withOpacity(0.6),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(width: SizeConfig.xMargin(context, 1.3)),
                  Expanded(
                    child: Center(
                      child: Container(
                        height: SizeConfig.xMargin(context, 17),
                        width: SizeConfig.xMargin(context, 17),
                        decoration: BoxDecoration(
                          // color: music.artWork == null ? kPrimary : null,
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: music.artWork == null
                            ? Image.asset(
                                'assets/cd-player.png',
                                fit: BoxFit.contain,
                              )
                            : Image.memory(
                                music.artWork!,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, obj, tr) {
                                  return Image.asset(
                                    'assets/cd-player.png',
                                    fit: BoxFit.contain,
                                  );
                                },
                              ),
                      ),
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
                          Spacer(),
                          Text(
                            music.title!,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: SizeConfig.textSize(context, 4),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          Text(
                            music.artist!,
                            maxLines: 1,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.color
                                  ?.withOpacity(0.6),
                              fontSize: SizeConfig.textSize(context, 3),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.xMargin(context, 6),
                  ),
                  Expanded(
                    child: Center(
                      child: InkWell(
                        onTap: () => model.onPlayButtonTap(),
                        child: ClayContainer(
                          curveType: CurveType.convex,
                          child: Icon(
                            model.isPlaying
                                ? mi.MdiIcons.pause
                                : mi.MdiIcons.play,
                            color: Colors.white,
                            size: SizeConfig.textSize(context, 5.5),
                          ),
                          depth: 50,
                          spread: 3,
                          color: Theme.of(context).colorScheme.secondary,
                          parentColor: Theme.of(context).backgroundColor,
                          height: SizeConfig.textSize(context, 8),
                          width: SizeConfig.textSize(context, 8),
                          borderRadius: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Container(height: 0, width: 0);
        }
      },
    );
  }
}

class MyMusicBarModel extends BaseModel {
  IPlayerControls _controls = locator<IPlayerControls>();
  AudioHandler _handler = locator<AudioHandler>();

  void onPlayButtonTap() async {
    if (_controls.isPlaying) {
      await _handler.pause();
    } else {
      print(nowPlaying?.filePath);
      if (_controls.playerState == AppPlayerState.Idle)
        await _handler.playFromMediaId(
            "${nowPlaying!.id}", {'path': nowPlaying!.filePath!});
      else
        await _handler.play();
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
