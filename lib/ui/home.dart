import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music_player/core/view_models/home_model.dart';
import 'package:music_player/ui/albums.dart';
import 'package:music_player/ui/artists.dart';
import 'package:music_player/ui/constants/colors.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    as mi;
import 'package:music_player/ui/shared/sizeConfig.dart';
import 'package:music_player/ui/songs.dart';

import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final List<Widget> tabs = [Songs(), Artists(), Albums()];
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeModel>(
      create: (context) => HomeModel(),
      child: Builder(builder: (context) {
        return Scaffold(
          body: Consumer<HomeModel>(builder: (context, provider, child) {
            return SafeArea(
              child: Container(
                width: SizeConfig.yMargin(context, 100),
                color: kbgColor,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: SizeConfig.yMargin(context, 16),
                        padding: EdgeInsets.fromLTRB(
                          SizeConfig.xMargin(context, 3),
                          SizeConfig.yMargin(context, 2),
                          SizeConfig.xMargin(context, 3),
                          0,
                        ),
                        color: kbgColor,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
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
                                ClayContainer(
                                  color: kbgColor,
                                  borderRadius: 10,
                                  child: Icon(mi.MdiIcons.magnify),
                                  height: SizeConfig.textSize(context, 10),
                                  width: SizeConfig.textSize(context, 10),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.yMargin(context, 3),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      provider.selected = 0;
                                    },
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Song',
                                            style: TextStyle(
                                              color: kBlack,
                                              fontSize: SizeConfig.textSize(
                                                  context, 5),
                                            ),
                                          ),
                                          SizedBox(
                                            height: SizeConfig.yMargin(
                                                context, 0.1),
                                          ),
                                          Container(
                                            height: SizeConfig.yMargin(
                                                context, 0.5),
                                            width:
                                                SizeConfig.xMargin(context, 2),
                                            decoration: BoxDecoration(
                                              color: provider.selected == 0
                                                  ? kPrimary
                                                  : kbgColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      provider.selected = 1;
                                    },
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Artists',
                                            style: TextStyle(
                                              color: kBlack,
                                              fontSize: SizeConfig.textSize(
                                                  context, 5),
                                            ),
                                          ),
                                          SizedBox(
                                            height: SizeConfig.yMargin(
                                                context, 0.1),
                                          ),
                                          Container(
                                            height: SizeConfig.yMargin(
                                                context, 0.5),
                                            width:
                                                SizeConfig.xMargin(context, 2),
                                            decoration: BoxDecoration(
                                              color: provider.selected == 1
                                                  ? kPrimary
                                                  : kbgColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      provider.selected = 2;
                                    },
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Album',
                                            style: TextStyle(
                                              color: kBlack,
                                              fontSize: SizeConfig.textSize(
                                                  context, 5),
                                            ),
                                          ),
                                          SizedBox(
                                            height: SizeConfig.yMargin(
                                                context, 0.1),
                                          ),
                                          Container(
                                            height: SizeConfig.yMargin(
                                                context, 0.5),
                                            width:
                                                SizeConfig.xMargin(context, 2),
                                            decoration: BoxDecoration(
                                              color: provider.selected == 2
                                                  ? kPrimary
                                                  : kbgColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(flex: 2),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    tabs[provider.selected],
                  ],
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
