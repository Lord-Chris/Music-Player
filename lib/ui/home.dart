import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music_player/core/view_models/home_model.dart';
import 'package:music_player/ui/albums.dart';
import 'package:music_player/ui/artists.dart';
import 'package:music_player/ui/constants/colors.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    as mi;
import 'package:music_player/ui/my_drawer.dart';
import 'package:music_player/ui/search.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';
import 'package:music_player/ui/songs.dart';
import 'package:music_player/ui/widget/music_bar.dart';

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
                // toolbarHeight: SizeConfig.yMargin(context, 13),
                backgroundColor: kbgColor,
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Builder(
                      builder: (context) {
                        return InkWell(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: ClayContainer(
                            color: kbgColor,
                            borderRadius: 10,
                            child: Icon(
                              mi.MdiIcons.alien,
                              color: kPrimary,
                            ),
                            height: SizeConfig.textSize(context, 10),
                            width: SizeConfig.textSize(context, 10),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                actions: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Search()));
                        },
                        child: ClayContainer(
                          color: kbgColor,
                          borderRadius: 10,
                          child: Icon(
                            mi.MdiIcons.magnify,
                            color: kSecondary,
                          ),
                          height: SizeConfig.textSize(context, 10),
                          width: SizeConfig.textSize(context, 10),
                        ),
                      ),
                      SizedBox(width: SizeConfig.xMargin(context, 2)),
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
              drawer: MyDrawer(),
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
              bottomNavigationBar: MyMusicBar(),
            ),
          ),
        );
      }),
    );
  }
}


