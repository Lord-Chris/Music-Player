import 'dart:io';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/models/artists.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/ui/views/base_view/base_view.dart';
import 'package:music_player/ui/views/my_list/my_list.dart';
import '../../shared/sizeConfig.dart';
import 'artists_model.dart';

class Artists extends StatelessWidget {
  final List<Artist>? list;

  const Artists({Key? key, this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseView<ArtistsModel>(
      builder: (context, model, child) {
        // print(list?.length ?? model.artistList.length);
        return Container(
          child: GridView.builder(
            padding: EdgeInsets.all(SizeConfig.xMargin(context, 3)),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, //SizeConfig.xMargin(context, 10),
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: list?.length ?? model.artistList.length,
            itemBuilder: (__, index) {
              Artist artist =
                  list == null ? model.artistList[index] : list![index];
              return Container(
                // color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        List<Track> response = await model.onTap(artist);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyList(
                              list: response,
                              pageTitle: artist.name,
                              listId: artist.name,
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
                            image: artist.artwork == null
                                ? DecorationImage(
                                    image: AssetImage(
                                        'assets/placeholder_image.png'),
                                    fit: BoxFit.scaleDown,
                                  )
                                : DecorationImage(
                                    image: FileImage(File(artist.artwork!)),
                                    fit: BoxFit.cover,
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
                        artist.name!,
                        maxLines: 2,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText2?.color,
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
                        'Songs: ' + artist.numberOfSongs!.toString(),
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.color
                              ?.withOpacity(0.6),
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
