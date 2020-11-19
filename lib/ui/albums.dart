import 'dart:io';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/models/albums.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/view_models/albums_model.dart';
import 'package:music_player/ui/my_list.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';
import 'base_view.dart';

class Albums extends StatelessWidget {
  final List<Album> list;

  const Albums({Key key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AlbumsModel>(
      builder: (context, model, child) {
        print(list?.length ?? model.albumList.length);
        return Container(
          height: SizeConfig.yMargin(context, 24),
          // padding:
          //     EdgeInsets.fromLTRB(0, SizeConfig.yMargin(context, 15), 0, 0),
          child: GridView.builder(
            padding: EdgeInsets.all(SizeConfig.xMargin(context, 3)),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, //SizeConfig.xMargin(context, 10),
              childAspectRatio: SizeConfig.yMargin(context, 0.08),
              crossAxisSpacing: SizeConfig.xMargin(context, 2),
              mainAxisSpacing: SizeConfig.yMargin(context, 1),
            ),
            itemCount: list?.length ?? model.albumList.length,
            itemBuilder: (__, index) {
              Album album = list == null ? model.albumList[index] : list[index];
              return Container(
                // color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        List<Track> response = await model.onTap(album.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MyList(list: response, pageTitle: album.title),
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
                              image: album.getArtWork() == null
                                  ? AssetImage('assets/placeholder_image.png')
                                  : FileImage(File(album.artwork)),
                              fit: album.getArtWork() == null
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
                        album.title,
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
                        'Songs: ' + album.numberOfSongs,
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
/**SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                runAlignment: WrapAlignment.spaceEvenly,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: model.albumList
                    .sublist(0, 40)
                    .map(
                      (album) => Container(
                        width: SizeConfig.xMargin(context, 30),
                        height: SizeConfig.yMargin(context, 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () async {
                                List<Track> response =
                                    await model.onTap(album.id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyList(
                                        list: response, pageTitle: album.title),
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    image: DecorationImage(
                                      image: album.artwork == null
                                          ? AssetImage(
                                              'assets/placeholder_image.png')
                                          : FileImage(File(album.artwork)),
                                      fit: album.artwork == null
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
                                color:
                                    Theme.of(context).textTheme.bodyText2.color,
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.yMargin(context, 0.5),
                            ),
                            Text(
                              'Songs: ' + album.numberOfSongs,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .color
                                    .withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ));
 * Cannot open file, path = '/storage/emulated/0/Android/data/com.android.providers.media/albumthumbs/1579560406094' (OS Error: No such file or directory, errno = 2)
 * 
 */
