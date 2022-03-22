import 'package:flutter/material.dart';
import 'package:musicool/core/models/albums.dart';
import 'package:musicool/ui/components/_components.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';

import 'albums_model.dart';

class AlbumsView extends StatelessWidget {
  final List<Album>? list;

  const AlbumsView({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _deviceWidth = MediaQuery.of(context).size.width;
    final _deviceHeight = MediaQuery.of(context).size.height;
    return BaseView<AlbumsModel>(
      builder: (context, model, child) {
        return AppBaseView<AlbumsView>(
          child: Column(
            children: [
              AppHeader(
                pageTitle: "Albums",
                image: AppAssets.albumsHeader,
                searchLabel: "Search albums",
                onFieldTap: model.onSearchTap,
              ),
              Expanded(
                child: model.albumList.isEmpty
                    ? Center(
                        child: Text(
                          'No albums found',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2?.color,
                            fontSize: 20,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 50),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: _deviceWidth / _deviceHeight * 1.65,
                          crossAxisSpacing: (_deviceWidth * 0.03),
                          mainAxisSpacing: 25,
                        ),
                        itemCount: list?.length ?? model.albumList.length,
                        itemBuilder: (__, index) {
                          Album album = list == null
                              ? model.albumList[index]
                              : list![index];
                          return MediaInfoCard(
                            onTap: () => model.onTap(album),
                            title: album.title!,
                            subTitle: "${album.numberOfSongs} song" +
                                (album.numberOfSongs! > 1 ? "s" : ""),
                            art: album.artwork,
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
