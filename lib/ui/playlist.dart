import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music_player/models/Playlistmodel.dart';
import 'package:music_player/ui/constants/colors.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    as mi;

import 'package:provider/provider.dart';

class Playlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size _mediaData = MediaQuery.of(context).size;
    return ChangeNotifierProvider<PlaylistProvider>(
      create: (context) => PlaylistProvider(),
      child: Builder(builder: (context) {
        return Scaffold(
          body: Consumer<PlaylistProvider>(builder: (context, provider, child) {
            return SafeArea(
              child: Container(
                padding: EdgeInsets.all(20.0),
                color: kbgColor,
                child: Column(
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
                    Row(
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
