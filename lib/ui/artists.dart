import 'dart:io';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/models/artists.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/view_models/artists_model.dart';
import 'package:music_player/ui/base_view.dart';
import 'package:music_player/ui/my_list.dart';
import 'shared/sizeConfig.dart';

class Artists extends StatelessWidget {
  final List<Artist> list;

  const Artists({Key key, this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseView<ArtistsModel>(
      builder: (context, model, child) {
        print(list?.length ?? model.artistList.length);
        return Container(
          // height: SizeConfig.yMargin(context, 24),
          // padding:
          //     EdgeInsets.fromLTRB(0, SizeConfig.yMargin(context, 15), 0, 0),
          child: GridView.builder(
            padding: EdgeInsets.all(SizeConfig.xMargin(context, 3)),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: SizeConfig.xMargin(context, 40),
              childAspectRatio: SizeConfig.yMargin(context, 0.08),
              crossAxisSpacing: SizeConfig.xMargin(context, 2),
              mainAxisSpacing: SizeConfig.yMargin(context, 1),
            ),
            itemCount: list?.length ?? model.artistList.length,
            itemBuilder: (__, index) {
              Artist artist =
                  list == null ? model.artistList[index] : list[index];
              return Container(
                // color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        List<Track> response = await model.onTap(artist.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyList(
                              list: response,
                              pageTitle: artist.name,
                            ),
                          ),
                        );
                      },
                      child: ClayContainer(
                        parentColor: Theme.of(context).backgroundColor,
                        color: Theme.of(context).accentColor,
                        borderRadius: 20,
                        width: SizeConfig.xMargin(context, 30),
                        height: SizeConfig.xMargin(context, 30),
                        curveType: CurveType.convex,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            image: DecorationImage(
                              image: artist.getArtWork() == null
                                  ? AssetImage('assets/placeholder_image.png')
                                  : FileImage(File(artist.artwork)),
                              fit: artist.getArtWork() == null
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.xMargin(context, 1)),
                      child: Text(
                        artist.name,
                        maxLines: 2,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText2.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.yMargin(context, 0.5),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.xMargin(context, 1)),
                      child: Text(
                        'Songs: ' + artist.numberOfSongs,
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .color
                              .withOpacity(0.6),
                        ),
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
