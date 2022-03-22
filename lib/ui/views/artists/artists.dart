import 'package:flutter/material.dart';
import 'package:musicool/core/models/artists.dart';
import 'package:musicool/ui/components/_components.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'artists_model.dart';

class ArtistsView extends StatelessWidget {
  final List<Artist>? list;

  const ArtistsView({Key? key, this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _deviceWidth = MediaQuery.of(context).size.width;
    final _deviceHeight = MediaQuery.of(context).size.height;
    return BaseView<ArtistsModel>(
      builder: (context, model, child) {
        return AppBaseView<ArtistsView>(
          child: Column(
            children: [
              const AppHeader(
                pageTitle: "Artists",
                image: AppAssets.artistsHeader,
                searchLabel: "Search artists",
              ),
              Expanded(
                child: model.artistList.isEmpty
                    ? Center(
                        child: Text(
                          'No artists found',
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
                          // (_deviceWidth %
                          //         (_deviceWidth / 3 - _deviceWidth * 0.1)) /
                          //     (_deviceWidth / (_deviceWidth / 3)),
                          mainAxisSpacing: 25,
                        ),
                        itemCount: list?.length ?? model.artistList.length,
                        itemBuilder: (__, index) {
                          Artist artist = list == null
                              ? model.artistList[index]
                              : list![index];
                          return MediaInfoCard(
                            onTap: () => model.onTap(artist),
                            title: artist.name!,
                            subTitle: "${artist.numberOfSongs} song" +
                                (artist.numberOfSongs! > 1 ? "s" : ""),
                            art: artist.artwork,
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