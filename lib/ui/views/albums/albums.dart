import 'dart:io';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:musicool/core/models/albums.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/views/my_list/my_list.dart';
import 'package:musicool/ui/shared/sizeConfig.dart';

import 'albums_model.dart';

class Albums extends StatelessWidget {
  final List<Album>? list;

  const Albums({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AlbumsModel>(
      builder: (context, model, child) {
        if (model.albumList.isEmpty) {
          return Center(
            child: Text(
              'No albums found',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText2?.color,
                fontSize: 20,
              ),
            ),
          );
        }
        return Container(
          height: SizeConfig.yMargin(context, 24),
          child: GridView.builder(
            padding: EdgeInsets.all(SizeConfig.xMargin(context, 3)),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, //SizeConfig.xMargin(context, 10),
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: list?.length ?? model.albumList.length,
            itemBuilder: (__, index) {
              Album album =
                  list == null ? model.albumList[index] : list![index];
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        List<Track> response = await model.onTap(album);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyList(
                              list: response,
                              pageTitle: album.title,
                              listId: album.id,
                            ),
                          ),
                        );
                      },
                      child: ClayContainer(
                        parentColor: Theme.of(context).backgroundColor,
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: 20,
                        width: SizeConfig.xMargin(context, 30),
                        height: SizeConfig.xMargin(context, 30),
                        curveType: CurveType.convex,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            image: album.artwork == null
                                ? DecorationImage(
                                    image: AssetImage(
                                        'assets/placeholder_image.png'),
                                    fit: BoxFit.scaleDown,
                                  )
                                : DecorationImage(
                                    image: FileImage(File(album.artwork!)),
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
                        album.title!,
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
                        'Songs: ' + album.numberOfSongs.toString(),
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
