import 'package:flutter/material.dart';
import 'package:music_player/core/view_models/my_drawer_model.dart';
import 'package:music_player/ui/base_view.dart';
import 'package:music_player/ui/playing.dart';
import 'package:music_player/ui/search.dart';
import 'package:music_player/ui/widget/icon.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<MyDrawerModel>(builder: (context, model, child) {
      return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: MyIcon(isInverted: true,)
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
            ),
            model.nowPlaying != null
                ? ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text('Now Playing'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (__) => Playing(
                            songId: model.nowPlaying.id,
                            play: false,
                          )));
                    },
                  )
                : Container(),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Search'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (__) => Search()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.shuffle),
              title: Text('Shuffle'),
              trailing: Switch(
                value: model.shuffle,
                onChanged: (val) => model.toggleShuffle(),
              ),
            ),
            // ListTile(
            //   leading: Icon(Icons.lightbulb_outline),
            //   title: Text('Dark Mode'),
            //   trailing: Switch(
            //     value: model.isDarkMode,
            //     onChanged: (val) => model.toggleDarkMode(),
            //   ),
            // ),
            Divider(),
          ],
        ),
      );
    });
  }
}
