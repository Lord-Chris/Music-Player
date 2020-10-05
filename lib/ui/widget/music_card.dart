import 'dart:io';

import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/ui/constants/colors.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';

import '../playing.dart';

class MyMusicCard extends StatelessWidget {
  final Track music;
  final int index;
  final List<Track> list;
  const MyMusicCard({
    Key key,
    this.music,
    this.index,
    this.list,
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
            MaterialPageRoute(
                builder: (context) => Playing(
                      index: index,
                      songs: list,
                    )),
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
                music.artWork == null
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
                            image: FileImage(File(music.artWork)),
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
