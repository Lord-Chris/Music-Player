import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music_player/core/view_models/home_model.dart';
import 'package:music_player/ui/albums.dart';
import 'package:music_player/ui/artists.dart';
import 'package:music_player/ui/base_view.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    as mi;
import 'package:music_player/ui/my_drawer.dart';
import 'package:music_player/ui/search.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';
import 'package:music_player/ui/songs.dart';
import 'package:music_player/ui/widget/music_bar.dart';

class Home extends StatelessWidget {
  final List<Widget> tabs = [Songs(), Artists(), Albums()];
  final List<String> tabsName = ['Songs', 'Artists', 'Albums'];
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      onModelReady: (model) => model.setState(),
      builder: (context, model, child) {
        return DefaultTabController(
          initialIndex: 2,
          length: tabsName.length,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: SizeConfig.yMargin(context, 14),
              backgroundColor: Theme.of(context).backgroundColor,
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Builder(
                    builder: (context) {
                      return InkWell(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: ClayContainer(
                          parentColor: Theme.of(context).shadowColor,
                          color: Theme.of(context).backgroundColor,
                          borderRadius: 10,
                          child: Icon(
                            mi.MdiIcons.alien,
                            color: Theme.of(context).accentColor,
                            size: SizeConfig.textSize(context, 5),
                          ),
                          height: SizeConfig.textSize(context, 10),
                          width: SizeConfig.textSize(context, 10),
                        ),
                      );
                    },
                  ),
                ],
              ),
              leadingWidth: SizeConfig.textSize(context, 13),
              actions: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Search()));
                      },
                      child: ClayContainer(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: 10,
                        child: Icon(
                          mi.MdiIcons.magnify,
                          color: Theme.of(context).accentColor,
                          size: SizeConfig.textSize(context, 5),
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
                tabs: tabsName.map((name) => Text(name)).toList(),
                indicatorWeight: SizeConfig.yMargin(context, 0.3),
                labelPadding: EdgeInsets.symmetric(
                    vertical: SizeConfig.yMargin(context, 1)),
                labelColor: Theme.of(context).textTheme.bodyText2.color,
                labelStyle: TextStyle(
                  fontSize: SizeConfig.textSize(context, 5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            drawer: MyDrawer(),
            body: Container(
              color: Theme.of(context).backgroundColor,
              child: TabBarView(
                children: tabs.map((tab) => tab).toList(),
              ),
            ),
            bottomNavigationBar: MyMusicBar(),
          ),
        );
      },
    );
  }
}
