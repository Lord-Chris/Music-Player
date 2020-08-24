import 'package:flutter/material.dart';
import 'package:music_player/ui/constants/colors.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    as mi;
import 'package:music_player/models/playingmodel.dart';
import 'package:provider/provider.dart';

class Playing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size _mediaData = MediaQuery.of(context).size;
    return ChangeNotifierProvider<PlayingProvider>(
      create: (context) => PlayingProvider(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Consumer<PlayingProvider>(
              builder: (context, provider, child) {
                return Container(
                  padding: EdgeInsets.all(20),
                  color: kbgColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          ClayContainer(
                            color: kbgColor,
                            borderRadius: 10,
                            child: Icon(mi.MdiIcons.arrowLeft),
                            height: _mediaData.width / 10 * 1,
                            width: _mediaData.width / 10 * 1,
                          ),
                          Expanded(
                            child: Center(
                              child: ClayText(
                                'Now Playing',
                                // emboss: true,
                                depth: 50,
                                color: Colors.black,
                                size: 18,
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                          ClayContainer(
                            color: kbgColor,
                            borderRadius: 10,
                            child: Icon(
                              mi.MdiIcons.heart,
                              color: Colors.pink,
                            ),
                            height: _mediaData.width / 10 * 1,
                            width: _mediaData.width / 10 * 1,
                          ),
                        ],
                      ),
                      ClayContainer(
                        depth: 50,
                        color: Colors.pinkAccent[400],
                        parentColor: kbgColor,
                        borderRadius: 20,
                        height: _mediaData.height / 10 * 4,
                        width: _mediaData.width / 10 * 6,
                      ),
                      Column(children: [
                        Text(
                          provider.musicName,
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .fontSize,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10),
                        Text(
                          provider.albumName,
                          style: TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.subtitle1.fontSize,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[500],
                          ),
                        ),
                      ]),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('01:41'),
                              Text('03:51'),
                            ],
                          ),
                          Slider(
                            value: provider.sliderPosition,
                            onChanged: (val) {
                              provider.onSliderChange(val);
                            },
                            activeColor: Colors.pinkAccent[400],
                            inactiveColor: Colors.white,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClayContainer(
                            child: Icon(
                              mi.MdiIcons.rewind,
                              color: Colors.grey[500],
                              size: 35,
                            ),
                            // curveType: CurveType.concave,
                            height: _mediaData.width / 10 * 1.9,
                            width: _mediaData.width / 10 * 1.9,
                            borderRadius: MediaQuery.of(context).size.width,
                          ),
                          ClayContainer(
                            child: Icon(
                              mi.MdiIcons.pause,
                              color: Colors.white,
                              size: 35,
                            ),
                            depth: 50,
                            color: Colors.pinkAccent[400],
                            parentColor: kbgColor,
                            // curveType: CurveType.concave,
                            height: _mediaData.width / 10 * 1.9,
                            width: _mediaData.width / 10 * 1.9,
                            borderRadius: MediaQuery.of(context).size.width,
                          ),
                          ClayContainer(
                            child: Icon(
                              mi.MdiIcons.fastForward,
                              color: Colors.grey[500],
                              size: 35,
                            ),
                            // curveType: CurveType.concave,
                            height: _mediaData.width / 10 * 1.9,
                            width: _mediaData.width / 10 * 1.9,
                            borderRadius: MediaQuery.of(context).size.width,
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
