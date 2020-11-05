import 'package:flutter/material.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/widget/music_bar.dart';
import 'package:music_player/ui/widget/music_card.dart';

class FavoritesScreen extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  final list = locator<SharedPrefs>().favorites;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Favorites',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText2.color,
          ),
        ),
      ),
      body: list.isEmpty 
      ? Center(
        child: Text('You don\'t have any favorite song',
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText2.color,
        ),),
      )
      : ListView.builder(
        controller: _controller,
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (__, index) {
          Track music = list[index];
          return MyMusicCard(
            music: music,
            list: list,
          );
        },
      ),
      bottomNavigationBar: MyMusicBar(),
    );
  }
}
