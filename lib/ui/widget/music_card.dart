import 'package:audio_service/audio_service.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:musicool/app/locator.dart';
import 'package:musicool/core/enums/app_player_state.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/shared/size_config.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    as mi;
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
    print(music?.artworkPath);
    print(music?.artwork);
    Track? _track = Provider.of<Track?>(context);
    return BaseView<MusicCardModel>(
      builder: (context, model, child) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.xMargin(context, 2),
            horizontal: SizeConfig.xMargin(context, 3),
          ),
          child: InkWell(
            onTap: () async {
              await locator<IPlayerService>().changeCurrentListOfSongs(listId);

              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Playing(song: music!);
              }));
            },
            child: ClayContainer(
              width: SizeConfig.xMargin(context, 100),
              borderRadius: 20,
              parentColor: Theme.of(context).backgroundColor,
              color: Theme.of(context).primaryColor,
              curveType: Theme.of(context).brightness == Brightness.light
                  ? CurveType.concave
                  : CurveType.convex,
              child: Padding(
                padding: EdgeInsets.all(
                  SizeConfig.xMargin(context, 3),
                ),
                child: Row(
                  children: [
                    Container(
                      height: SizeConfig.xMargin(context, 17),
                      width: SizeConfig.xMargin(context, 17),
                      decoration: const BoxDecoration(
                        // color: music.artwork == null ? kPrimary : null,
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: music!.artwork == null
                          ? Image.asset(
                              'assets/cd-player.png',
                              fit: BoxFit.contain,
                            )
                          : Image.memory(
                              music!.artwork!,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, obj, tr) {
                                return Image.asset(
                                  'assets/cd-player.png',
                                  fit: BoxFit.contain,
                                );
                              },
                            ),
                    ),
                    SizedBox(width: SizeConfig.xMargin(context, 6)),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          // Spacer(),
                          Text(
                            music!.title!,
                            maxLines: 1,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                                fontSize: SizeConfig.textSize(context, 4),
                                fontWeight: FontWeight.w400),
                          ),
                          // Spacer(flex: 2),
                          Text(
                            music!.artist!,
                            maxLines: 1,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.color!
                                  .withOpacity(0.6),
                              fontSize: SizeConfig.textSize(context, 3),
                            ),
                          ),
                          // Spacer(),
                          Text(
                            music!.toTime(),
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.color!
                                  .withOpacity(0.6),
                              fontSize: SizeConfig.textSize(context, 3),
                            ),
                          ),
                          // Spacer(flex: 3),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.xMargin(context, 2),
                    ),
                    _track?.id == music?.id
                        ? StreamBuilder<AppPlayerState>(
                            stream: model.playerStateStream,
                            builder: (context, snapshot) {
                              return InkWell(
                                onTap: () => model.onTap(music!.id!),
                                child: ClayContainer(
                                  curveType: CurveType.convex,
                                  child: Icon(
                                    model.isPlaying &&
                                            model.currentTrack?.id == music!.id
                                        ? mi.MdiIcons.pause
                                        : mi.MdiIcons.play,
                                    color: Colors.white,
                                    size: SizeConfig.textSize(context, 6),
                                  ),
                                  depth: 30,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  parentColor:
                                      Theme.of(context).backgroundColor,
                                  spread: 4,
                                  // curveType: CurveType.concave,
                                  height: SizeConfig.textSize(context, 8),
                                  width: SizeConfig.textSize(context, 8),
                                  borderRadius:
                                      MediaQuery.of(context).size.width,
                                ),
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
                            return MyBottomSheet(
                              track: music,
                            );
                          }),
                      child: Icon(
                        Icons.more_vert,
                        color: Theme.of(context).colorScheme.secondary,
                        size: SizeConfig.textSize(context, 6),
                      ),
                    )
                  ],
                ),
              ),
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

  onTap(String id) async {
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

  bool get isPlaying => _controls.isPlaying;
  Stream<AppPlayerState> get playerStateStream => _controls.playerStateStream;
  Track? get currentTrack => _controls.getCurrentTrack();
}
