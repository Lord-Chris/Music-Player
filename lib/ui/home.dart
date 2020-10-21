import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/view_models/home_model.dart';
import 'package:music_player/ui/albums.dart';
import 'package:music_player/ui/artists.dart';
import 'package:music_player/ui/constants/colors.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    as mi;
import 'package:music_player/ui/playing.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';
import 'package:music_player/ui/songs.dart';

import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final List<Widget> tabs = [Songs(), Artists(), Albums()];
  final List<String> tabsName = ['Songs', 'Artists', 'Albums'];
  @override
  Widget build(BuildContext context) {
    // TabController tabController = DefaultTabController.of(context);
    return ChangeNotifierProvider<HomeModel>(
      create: (context) => HomeModel(),
      child: Consumer<HomeModel>(builder: (context, model, child) {
        return SafeArea(
          child: DefaultTabController(
            length: tabsName.length,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: SizeConfig.yMargin(context, 13),
                backgroundColor: kbgColor,
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClayContainer(
                      color: kbgColor,
                      borderRadius: 10,
                      child: Icon(
                        mi.MdiIcons.alien,
                        color: kPrimary,
                      ),
                      height: SizeConfig.textSize(context, 10),
                      width: SizeConfig.textSize(context, 10),
                    ),
                  ],
                ),
                actions: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClayContainer(
                        color: kbgColor,
                        borderRadius: 10,
                        child: Icon(
                          mi.MdiIcons.magnify,
                          color: kSecondary,
                        ),
                        height: SizeConfig.textSize(context, 10),
                        width: SizeConfig.textSize(context, 10),
                      ),
                    ],
                  ),
                ],
                bottom: TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: tabsName
                      .map((name) => Container(
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.yMargin(context, 1)),
                            child: Text(
                              name,
                              style: TextStyle(
                                color: kSecondary,
                                fontSize: SizeConfig.textSize(context, 5),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              body: Container(
                decoration: BoxDecoration(
                  color: kbgColor,
                  // image: DecorationImage(
                  // image: AssetImage('assets/bg-image.jpg'),
                  // fit: BoxFit.cover,
                  // ),
                ),
                child: TabBarView(
                  children: tabs,
                ),
              ),
              bottomNavigationBar: StreamBuilder<Track>(
                stream: model.test(),
                builder: (context, snapshot) {
                  Track music = snapshot.data;
                  return music?.displayName != null
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Playing(
                                        index: model.nowPlaying.index,
// songs: list,
                                      )),
                            );
                          },
                          child: Container(
                            height: SizeConfig.yMargin(context, 8),
                            width: SizeConfig.xMargin(context, 100),
                            decoration: BoxDecoration(
                              color: kbgColor,
                              boxShadow: [
                                BoxShadow(
                                  color: kSecondary.withOpacity(0.6),
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: CircleAvatar(
                                      backgroundImage: music.artWork == null
                                          ? AssetImage('assets/cd-player.png')
                                          : FileImage(File(music.artWork)),
                                      backgroundColor: klight,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.xMargin(context, 6),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        SizeConfig.yMargin(context, 0.3)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            music.displayName,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: SizeConfig.textSize(
                                                  context, 4),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          music.artist,
                                          maxLines: 2,
                                          style: TextStyle(
                                            color: kSecondary.withOpacity(0.6),
                                            fontSize:
                                                SizeConfig.textSize(context, 3),
                                          ),
                                        ),
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
                                          model.state ==
                                                  AudioPlayerState.PLAYING
                                              ? mi.MdiIcons.pause
                                              : mi.MdiIcons.play,
                                          color: Colors.white,
                                          size: SizeConfig.textSize(context, 6),
                                        ),
                                        depth: 50,
                                        color: kPrimary,
                                        parentColor: kbgColor,
// curveType: CurveType.concave,
                                        height: SizeConfig.textSize(context, 9),
                                        width: SizeConfig.textSize(context, 9),
                                        borderRadius:
                                            MediaQuery.of(context).size.width,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(height: 0, width: 0);
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
