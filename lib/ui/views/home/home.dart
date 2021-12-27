import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:musicool/ui/constants/colors.dart';
import 'package:musicool/ui/views/albums/albums.dart';
import 'package:musicool/ui/views/artists/artists.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    as mi;
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/views/my_drawer/my_drawer.dart';
import 'package:musicool/ui/views/search/search.dart';
import 'package:musicool/ui/shared/sizeConfig.dart';
import 'package:musicool/ui/views/songs/songs.dart';
import 'package:musicool/ui/widget/music_bar.dart';

import '../../constants/unique_keys.dart';
import 'home_model.dart';

class Home extends StatelessWidget {
  final List<Widget> tabs = [Songs(), Artists(), Albums()];
  final List<String> tabsName = ['Songs', 'Artists', 'Albums'];
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      onModelReady: (model) => model.onModelReady(),
      onModelFinished: (model) => model.onModelFinished(),
      builder: (context, model, child) {
        return DefaultTabController(
          length: tabsName.length,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 130,
              backgroundColor: Theme.of(context).backgroundColor,
              leading: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Builder(
                    builder: (context) {
                      return InkWell(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: ClayContainer(
                          parentColor: Theme.of(context).backgroundColor,
                          color: Theme.of(context).backgroundColor,
                          borderRadius: 10,
                          child: Icon(
                            mi.MdiIcons.menu,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 30,
                          ),
                          height: 50,
                          width: 50,
                        ),
                      );
                    },
                  ),
                ],
              ),
              leadingWidth: SizeConfig.textSize(context, 12),
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
                          color: Theme.of(context).colorScheme.secondary,
                          size: 30,
                        ),
                        height: 50,
                        width: 50,
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
                indicatorColor: ThemeColors.kPrimary,
                labelPadding: EdgeInsets.symmetric(
                    vertical: SizeConfig.yMargin(context, 1)),
                labelColor: Theme.of(context).textTheme.bodyText2?.color,
                labelStyle: TextStyle(
                  fontSize: SizeConfig.textSize(context, 5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            drawer: MyDrawer(),
            body: Container(
              key: UniqueKeys.HOMECONTAINER,
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
