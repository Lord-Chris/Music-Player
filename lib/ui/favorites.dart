import 'package:flutter/material.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/widget/music_bar.dart';
import 'package:music_player/ui/widget/music_card.dart';

class FavoritesScreen extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  // final list = locator<SharedPrefs>().favorites;

  Stream<List<Track>> streamFavorites() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 500));
      yield locator<SharedPrefs>().favorites;
    }
  }

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
      body: StreamBuilder<List<Track>>(
          stream: streamFavorites(),
          builder: (context, snapshot) {
            if (snapshot.data== null || snapshot.data .isEmpty) {
              return Center(
                child: Text(
                  'You don\'t have any favorite song',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText2.color,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                controller: _controller,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (__, index) {
                  Track music = snapshot.data[index];
                  return MyMusicCard(
                    music: music,
                    list: snapshot.data,
                  );
                },
              );
            }
          }),
      bottomNavigationBar: MyMusicBar(),
    );
  }
}
