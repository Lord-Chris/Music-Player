import 'dart:io';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/view_models/albums_model.dart';
import 'package:music_player/ui/my_list.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';
import 'base_view.dart';
import 'constants/colors.dart';

class Albums extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<AlbumsModel>(
      builder: (context, model, child) {
        print(model.albumList.length);
        return Container(
          height: SizeConfig.yMargin(context, 24),
          // padding:
          //     EdgeInsets.fromLTRB(0, SizeConfig.yMargin(context, 15), 0, 0),
          child: GridView.builder(
            padding: EdgeInsets.all(SizeConfig.xMargin(context, 3)),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: SizeConfig.xMargin(context, 40),
              childAspectRatio: SizeConfig.textSize(context, 0.15),
              crossAxisSpacing: SizeConfig.xMargin(context, 2),
              mainAxisSpacing: SizeConfig.yMargin(context, 1),
            ),
            itemCount: model.albumList.length,
            itemBuilder: (__, index) {
              AlbumInfo album = model.albumList[index];
              return Container(
                // color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        List<Track> response = await model.onTap(index);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MyList(list: response, pageTitle: album.title),
                          ),
                        );
                      },
                      child: ClayContainer(
                        parentColor: kbgColor,
                        color: kPrimary,
                        borderRadius: 20,
                        width: SizeConfig.xMargin(context, 30),
                        height: SizeConfig.xMargin(context, 30),
                        curveType: CurveType.convex,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            image: DecorationImage(
                              image: album.albumArt == null
                                  ? AssetImage('assets/placeholder_image.png')
                                  : FileImage(File(album.albumArt)),
                              fit: album.albumArt == null
                                  ? BoxFit.scaleDown
                                  : BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.yMargin(context, 1),
                    ),
                    Text(
                      'Album: ' + album.title,
                      maxLines: 2,
                      style: TextStyle(
                        color: kSecondary,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.yMargin(context, 0.5),
                    ),
                    Text(
                      'Songs: ' + album.numberOfSongs,
                      style: TextStyle(
                        color: kSecondary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
