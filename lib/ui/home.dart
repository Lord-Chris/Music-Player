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
                toolbarHeight: SizeConfig.yMargin(context, 12),
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
                          color: kBlack,
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
                      .map((name) => Text(
                            name,
                            style: TextStyle(
                              color: kBlack,
                              fontSize: SizeConfig.textSize(context, 5),
                            ),
                          ))
                      .toList(),
                ),
              ),
              body: TabBarView(
                children: tabs,
              ),
//               bottomNavigationBar: StreamBuilder<Track>(
//                 stream: model.test(),
//                 builder: (context, snapshot) {
//                   Track music = snapshot.data;
//                   return music?.displayName != null
//                       ? GestureDetector(
//                           onHorizontalDragStart: (details) {
//                             print(details.globalPosition);
//                             model.start = details.globalPosition.dx;
//                           },
//                           onPanEnd: (details) {
// // print(details.globalPosition);
// // model
// //     .dragFinished(details.globalPosition);
//                           },
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => Playing(
//                                         index: model.nowPlaying.index,
// // songs: list,
//                                       )),
//                             );
//                           },
//                           child: Container(
//                             height: SizeConfig.yMargin(context, 9),
//                             width: SizeConfig.xMargin(context, 100),
//                             color: kbgColor,
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Center(
//                                     child: Container(
//                                       height: SizeConfig.xMargin(context, 10),
//                                       width: SizeConfig.xMargin(context, 10),
//                                       decoration: BoxDecoration(
//                                         color: kPrimary,
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(10)),
//                                         image: DecorationImage(
//                                           image: music.artWork == null
//                                               ? AssetImage(
//                                                   'assets/placeholder_image.png')
//                                               : FileImage(
//                                                   File(music.artWork),
//                                                 ),
//                                           fit: music.artWork == null
//                                               ? BoxFit.scaleDown
//                                               : BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 5,
//                                   child: Center(
//                                     child: Text(
//                                       music.displayName ??
//                                           'Song Name and Title is verry long oooooo ooooooooo',
//                                       style: TextStyle(
//                                         fontSize:
//                                             SizeConfig.textSize(context, 4),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Center(
//                                     child: InkWell(
//                                       onTap: () => model.onPlayButtonTap(),
//                                       child: ClayContainer(
//                                         child: Icon(
//                                           model.state ==
//                                                   AudioPlayerState.PLAYING
//                                               ? mi.MdiIcons.pause
//                                               : mi.MdiIcons.play,
//                                           color: Colors.white,
//                                           size: SizeConfig.textSize(context, 6),
//                                         ),
//                                         depth: 50,
//                                         color: kPrimary,
//                                         parentColor: kbgColor,
// // curveType: CurveType.concave,
//                                         height: SizeConfig.textSize(context, 9),
//                                         width: SizeConfig.textSize(context, 9),
//                                         borderRadius:
//                                             MediaQuery.of(context).size.width,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         )
//                       : Container();
//                 },
//               ),
            ),
          ),
        );
      }),
    );
  }
}
