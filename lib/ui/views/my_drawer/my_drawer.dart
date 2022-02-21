import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/views/my_drawer/my_drawer_model.dart';
import 'package:musicool/ui/favorites.dart';
import 'package:musicool/ui/views/playing/playing.dart';
import 'package:musicool/ui/views/search/search.dart';
import 'package:musicool/ui/widget/icon.dart';

import '../../constants/unique_keys.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<MyDrawerModel>(builder: (context, model, child) {
      return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: const Center(
                child: MyIcon(
                  isInverted: true,
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Visibility(
              visible: model.nowPlaying != null,
              child: ListTile(
                leading: const Icon(Icons.play_arrow),
                title: const Text('Now Playing'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (__) => Playing(song: model.nowPlaying)));
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (__) => Search()));
              },
            ),
            ListTile(
              leading: const Icon(MdiIcons.heart),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (__) => FavoritesScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.shuffle),
              title: const Text('Shuffle'),
              trailing: Switch(
                value: model.shuffle,
                onChanged: (val) => model.toggleShuffle(),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Dark Mode'),
              trailing: Switch(
                key: UniqueKeys.DARKMODE,
                value: model.isDarkMode,
                onChanged: (val) => model.toggleDarkMode(),
              ),
            ),
            const Divider(),
          ],
        ),
      );
    });
  }
}
