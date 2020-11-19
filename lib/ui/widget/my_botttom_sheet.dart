import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/controls_util.dart';
import 'package:music_player/core/utils/files_utils.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';

class MyBottomSheet extends StatelessWidget {
  final SharedPrefs _prefs = locator<SharedPrefs>();
  final Track track;

  MyBottomSheet({Key key, this.track}) : super(key: key);
  bool checkFav() {
    List<Track> list =
        _prefs.favorites.where((element) => element.id == track.id).toList();
    return list == null || list.isEmpty ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    FileUtils _utils = FileUtils(track);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: SizeConfig.xMargin(context, 19),
            padding: EdgeInsets.all(SizeConfig.xMargin(context, 1)),
            child: Row(
              children: [
                Container(
                  height: SizeConfig.xMargin(context, 17),
                  width: SizeConfig.xMargin(context, 17),
                  decoration: BoxDecoration(
                    // color: music.artWork == null ? kPrimary : null,
                    borderRadius: BorderRadius.all(
                        Radius.circular(SizeConfig.xMargin(context, 100))),
                    image: DecorationImage(
                      image: track.artWork == null
                          ? AssetImage('assets/cd-player.png')
                          : FileImage(File(track.artWork)),
                      fit:
                          track.artWork == null ? BoxFit.contain : BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.xMargin(context, 6),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(),
                        Text(
                          track.title,
                          maxLines: 2,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2.color,
                              fontSize: SizeConfig.textSize(context, 4),
                              fontWeight: FontWeight.w400),
                        ),
                        Spacer(),
                        Text(
                          track.artist,
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .color
                                .withOpacity(0.6),
                            fontSize: SizeConfig.textSize(context, 3),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              MdiIcons.heart,
              size: SizeConfig.textSize(context, 6),
              color: checkFav()
                  ? Theme.of(context).accentColor
                  : Theme.of(context).backgroundColor,
            ),
            title: Text(
              checkFav() ? 'Remove from Favorites' : 'Add to Favorites',
            ),
            onTap: () {
              Navigator.pop(context);
              locator<AudioControls>().toggleFav(track);
            },
          ),
          ListTile(
            leading: Icon(
              MdiIcons.share,
              size: SizeConfig.textSize(context, 6),
              color: Theme.of(context).accentColor,
            ),
            title: Text('Share'),
            onTap: () {
              Navigator.pop(context);
              _utils.share();
            },
          ),
          ListTile(
            leading: Icon(
              MdiIcons.information,
              size: SizeConfig.textSize(context, 6),
              color: Theme.of(context).accentColor,
            ),
            title: Text('Properties'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (__) => MyPropertiesDialog(track: track),
              );
            },
          ),
          // ListTile(
          //   leading: Icon(
          //     MdiIcons.pencil,
          //     size: SizeConfig.textSize(context, 6),
          //     color: Theme.of(context).accentColor,
          //   ),
          //   title: Text('Rename'),
          //   onTap: () {
          //     print(track.displayName);
          //     _utils.rename('stuff');
          //   },
          // ),
          // ListTile(
          //   leading: Icon(
          //     MdiIcons.trashCan,
          //     size: SizeConfig.textSize(context, 6),
          //     color: Theme.of(context).accentColor,
          //   ),
          //   title: Text('Delete'),
          // ),
        ],
      ),
    );
  }
}

class MyPropertiesDialog extends StatelessWidget {
  const MyPropertiesDialog({
    Key key,
    @required this.track,
  }) : super(key: key);

  final Track track;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.textSize(context, 5)),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      child: Container(
        height: SizeConfig.yMargin(context, 40),
        width: SizeConfig.xMargin(context, 70),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(track.artWork == null
                    ? SizeConfig.textSize(context, 5)
                    : 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.xMargin(context, 5)),
                    topRight: Radius.circular(SizeConfig.xMargin(context, 5)),
                  ),
                  image: DecorationImage(
                    image: track.artWork == null
                        ? AssetImage('assets/cd-player.png')
                        : FileImage(File(track.artWork)),
                    fit:
                        track.artWork == null ? BoxFit.scaleDown : BoxFit.cover,
                  ),
                ),
              ),
            ),
            track.artWork == null
                ? Divider(color: Theme.of(context).textTheme.bodyText2.color)
                : Container(),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(SizeConfig.xMargin(context, 2)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Artist: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color:
                                  Theme.of(context).textTheme.bodyText2.color,
                            ),
                          ),
                          TextSpan(
                            text: track.artist,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Duration: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color:
                                  Theme.of(context).textTheme.bodyText2.color,
                            ),
                          ),
                          TextSpan(
                            text: track.toTime(),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Size: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color:
                                  Theme.of(context).textTheme.bodyText2.color,
                            ),
                          ),
                          TextSpan(
                            text: track.toSize(),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Location: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color:
                                  Theme.of(context).textTheme.bodyText2.color,
                            ),
                          ),
                          TextSpan(
                            text: track.filePath,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // RichText(
                    //   text: TextSpan(
                    //     children: [
                    //       TextSpan(text: 'Album: '),
                    //       TextSpan(text: track.album),
                    //     ],
                    //   ),
                    // ),
                    // RichText(
                    //   text: TextSpan(
                    //     children: [
                    //       TextSpan(text: 'Artist'),
                    //       TextSpan(text: track.artist),
                    //     ],
                    //   ),
                    // ),
                    // RichText(
                    //   text: TextSpan(
                    //     children: [
                    //       TextSpan(text: 'Artist'),
                    //       TextSpan(text: track.artist),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
