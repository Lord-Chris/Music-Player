import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/core/models/music.dart';
import 'package:music_player/ui/base_view.dart';
import 'package:music_player/ui/playing.dart';

class Playlist extends StatelessWidget {
  Music _music = Music();
//  AudioPlayer .logEnabled = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _music.songsList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<SongInfo> data = snapshot.data;
            return ListView.builder(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Playing(
                          song: data[index],
                          songs: data,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Text(data[index].title.toString()),
                  ),
                );
              },
              itemCount: data.length,
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
