import 'package:musicool/app/index.dart';
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
    return BaseView<ArtistsModel>(
      builder: (context, model, child) {
        return AppBaseView<ArtistsView>(
          child: Column(
            children: [
              AppHeader(
                pageTitle: "Artists",
                image: AppAssets.artistsHeader,
                searchLabel: "Search artists",
                onFieldTap: model.onSearchTap,
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 100.w / 145.h,
                          crossAxisSpacing: 16.sp,
                          mainAxisSpacing: 20.h,
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
