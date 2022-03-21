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
              const AppHeader(
                pageTitle: "Albums",
                image: AppAssets.albumsHeader,
                searchLabel: "Search albums",
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
                          return InkWell(
                            onTap: () => model.onTap(album),
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.main,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          child: MediaArt(
                                            size: 145,
                                            art: album.artwork,
                                            defArtSize: 70,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: -5,
                                          right: -5,
                                          child: PlayButton(
                                            size: 4,
                                            onTap: () {},
                                            showPause: false,
                                          ),
                                        ),
                                        Positioned(
                                          top: 15,
                                          right: 15,
                                          child: false
                                              // ignore: dead_code
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    child: Center(
                                                      child: Text(
                                                        "_item.duration!",
                                                        style: kLittleStyle,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const YMargin(10),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: Text(
                                      album.title ?? "",
                                      style: kBodyStyle,
                                      maxLines: 1,
                                    ),
                                  ),
                                  const YMargin(5),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: Text(
                                      "${album.numberOfSongs} song" +
                                          (album.numberOfSongs! > 1 ? "s" : ""),
                                      style: kSubBodyStyle,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
