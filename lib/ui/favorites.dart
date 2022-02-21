import 'package:flutter/material.dart';
import 'package:musicool/app/locator.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/constants/pref_keys.dart';
import 'package:musicool/ui/widget/music_bar.dart';
import 'package:musicool/ui/widget/music_card.dart';

class FavoritesScreen extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  final _music = locator<IAudioFileService>();

  FavoritesScreen({Key? key}) : super(key: key);

  Stream<List<Track>> streamFavorites() async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));
      yield _music.favorites;
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
            color: Theme.of(context).textTheme.bodyText2?.color,
          ),
        ),
      ),
      body: StreamBuilder<List<Track>>(
          initialData: _music.favorites,
          stream: streamFavorites(),
          builder: (context, snapshot) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'You don\'t have any favorite song',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText2?.color,
                    fontSize: 20,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                controller: _controller,
                shrinkWrap: true,
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (__, index) {
                  Track music = snapshot.data![index];
                  return MyMusicCard(
                    music: music,
                    listId: FAVORITES,
                  );
                },
              );
            }
          }),
      bottomNavigationBar: const MyMusicBar(),
    );
  }
}
