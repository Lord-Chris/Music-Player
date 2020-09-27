import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'file:///C:/Users/chris/Desktop/Mobile%20Dev/Flutter%20Projects/music_player/lib/core/viewmodels/Playlistmodel.dart';
import 'package:music_player/ui/constants/colors.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    as mi;
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/core/models/music.dart';
import 'package:music_player/ui/base_view.dart';
import 'package:music_player/ui/playing.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';

import 'package:provider/provider.dart';

class Playlist extends StatelessWidget {
  ScrollController _controller = ScrollController();
  test(id) async {
    print('starting');
    var stuff = FlutterAudioQuery().getArtwork(type: ResourceType.SONG, id: id);
    print(stuff);
    // List<SongInfo> _listOfSongs = await FlutterAudioQuery().getSongs();
    // for (SongInfo song in _listOfSongs) {
    //   var stuff =
    //       FlutterAudioQuery().getArtwork(type: ResourceType.SONG, id: song.id);
    //   print(stuff);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlaylistProvider>(
      create: (context) => PlaylistProvider(),
      child: Builder(builder: (context) {
        return Scaffold(
          body: Consumer<PlaylistProvider>(builder: (context, provider, child) {
            // test(provider.musicList[0].id);
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
                        height: SizeConfig.yMargin(context, 15),
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
                                InkWell(
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
                                            fontSize:
                                                SizeConfig.textSize(context, 5),
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              SizeConfig.yMargin(context, 0.1),
                                        ),
                                        Container(
                                          height:
                                              SizeConfig.yMargin(context, 0.5),
                                          width: SizeConfig.xMargin(context, 2),
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
                                InkWell(
                                  onTap: () {
                                    provider.selected = 1;
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.xMargin(context, 2),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Artists',
                                          style: TextStyle(
                                            color: kBlack,
                                            fontSize:
                                                SizeConfig.textSize(context, 5),
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              SizeConfig.yMargin(context, 0.1),
                                        ),
                                        Container(
                                          height:
                                              SizeConfig.yMargin(context, 0.5),
                                          width: SizeConfig.xMargin(context, 2),
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
                                InkWell(
                                  onTap: () {
                                    provider.selected = 2;
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.xMargin(context, 2),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Album',
                                          style: TextStyle(
                                            color: kBlack,
                                            fontSize:
                                                SizeConfig.textSize(context, 5),
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              SizeConfig.yMargin(context, 0.1),
                                        ),
                                        Container(
                                          height:
                                              SizeConfig.yMargin(context, 0.5),
                                          width: SizeConfig.xMargin(context, 2),
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: SizeConfig.yMargin(context, 15),
                      right: 0,
                      left: 0,
                      child: Container(
                        color: kbgColor,
                        height: SizeConfig.yMargin(context, 82),
                        width: SizeConfig.xMargin(context, 100),
                        child: ListView(
                          controller: _controller,
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: SizeConfig.yMargin(context, 1),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.xMargin(context, 3),
                              ),
                              child: Text(
                                'Recently Played',
                                style: TextStyle(
                                  color: kBlack,
                                  fontSize: SizeConfig.textSize(context, 5),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.yMargin(context, 2),
                            ),
                            Container(
                              height: SizeConfig.yMargin(context, 24),
                              child: ListView.separated(
                                padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.xMargin(context, 3),
                                ),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: 10,
                                separatorBuilder: (__, index) => Padding(
                                    padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.xMargin(context, 2),
                                )),
                                itemBuilder: (__, index) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: SizeConfig.xMargin(context, 30),
                                        height: SizeConfig.xMargin(context, 30),
                                        decoration: BoxDecoration(
                                          color: kPrimary,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.yMargin(context, 1),
                                      ),
                                      Text(
                                        'Title',
                                        style: TextStyle(
                                          color: kBlack,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            SizeConfig.yMargin(context, 0.5),
                                      ),
                                      Text(
                                        'Artist',
                                        style: TextStyle(
                                          color: kBlack,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.xMargin(context, 3),
                              ),
                              child: Text(
                                'All Songs',
                                style: TextStyle(
                                  color: kBlack,
                                  fontSize: SizeConfig.textSize(context, 5),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.xMargin(context, 3),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: provider.musicList
                                    .sublist(0, 50)
                                    .map((music) {
                                  return MyMusicCard(
                                    music: music,
                                    provider: provider,
                                    index: provider.musicList.indexOf(music),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

class MyMusicCard extends StatelessWidget {
  final SongInfo music;
  final PlaylistProvider provider;
  final int index;
  const MyMusicCard({
    Key key,
    this.music,
    this.provider,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.xMargin(context, 2),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Playing(index: index)),
          );
        },
        child: ClayContainer(
          height: 100,
          width: SizeConfig.xMargin(context, 100),
          borderRadius: 20,
          color: kbgColor,
          child: Padding(
            padding: EdgeInsets.all(
              SizeConfig.xMargin(context, 3),
            ),
            child: Row(
              children: [
                music.albumArtwork == null
                    ? Container(
                        height: SizeConfig.xMargin(context, 17),
                        width: SizeConfig.xMargin(context, 17),
                        decoration: BoxDecoration(
                          color: kPrimary,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                            image: AssetImage('assets/placeholder_image.png'),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      )
                    : Container(
                        height: SizeConfig.xMargin(context, 17),
                        width: SizeConfig.xMargin(context, 17),
                        decoration: BoxDecoration(
                          color: kPrimary,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                            image: FileImage(File(music.albumArtwork)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                SizedBox(
                  width: SizeConfig.xMargin(context, 2),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            music.displayName,
                            style: TextStyle(
                              color: kBlack,
                              fontSize: SizeConfig.textSize(context, 4),
                            ),
                          ),
                        ),
                        // Flexible(
                        //   child: Text(
                        //     music.artist,
                        //     style: TextStyle(
                        //       color: kBlack,
                        //       fontSize:
                        //           SizeConfig.textSize(
                        //               context, 3),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.xMargin(context, 2),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert,
                    color: kPrimary,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*Row(
                      children: [
                        Expanded(
                          child: ClayContainer(
                            color: kbgColor,
                            borderRadius: 10,
                            height: _mediaData.width / 10 * 1.2,
                            width: _mediaData.width / 10 * 2,
                            child: Row(
                              children: [
                                ClayContainer(
                                  parentColor: kbgColor,
                                  color: Colors.pink,
//                                  depth: 100,
                                  height: _mediaData.width / 10 * 0.8,
                                  width: _mediaData.width / 10 * 0.9,
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 5.0),
                                      child: Text(
                                        'My Audience',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Text(
                                        'Artist - Derbyaba Album',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: ClayContainer(
                                    child: Icon(
                                      mi.MdiIcons.pause,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                    depth: 50,
                                    color: Colors.pinkAccent[400],
                                    parentColor: kbgColor,
                                    height: _mediaData.width / 10 * 1.0,
                                    width: _mediaData.width / 10 * 1.0,
                                    borderRadius: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),*/
/*Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ClayContainer(
                          color: kbgColor,
                          borderRadius: 10,
                          child: Icon(mi.MdiIcons.magnify),
                          height: _mediaData.width / 10 * 1,
                          width: _mediaData.width / 10 * 1,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      'Playlists',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 30.0,
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ClayContainer(
                            color: kbgColor,
                            borderRadius: 20,
                            depth: 50,
                            height: _mediaData.height / 10 * 2.5,
                            width: _mediaData.width / 10 * 7.2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: ClayContainer(
                                    color: kbgColor,
                                    borderRadius: 10,
                                    child: Icon(
                                      mi.MdiIcons.heart,
                                      color: Colors.pink,
                                    ),
                                    height: _mediaData.width / 10 * 1,
                                    width: _mediaData.width / 10 * 1,
                                  ),
                                ),
                                SizedBox(
                                  height: 40.0,
                                ),
                                Text(
                                  'Favorites',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      'Recommended',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              ClayContainer(
                                color: kbgColor,
                                borderRadius: 20,
                                height: _mediaData.width / 10 * 5,
                                width: _mediaData.width / 10 * 3.3,
                              ),
                              SizedBox(
                                width: 25.0,
                              ),
                              ClayContainer(
                                color: kbgColor,
                                borderRadius: 20,
                                height: _mediaData.width / 10 * 5,
                                width: _mediaData.width / 10 * 3.3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                  ],
                ),*/
