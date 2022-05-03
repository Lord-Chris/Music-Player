import 'package:musicool/app/index.dart';
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
                          style: kSubBodyStyle.copyWith(fontSize: 16.sm),
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.fromLTRB(10.w, 20.h, 10.w, 100.h),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 100.w / 145.h,
                          crossAxisSpacing: 16.sp,
                          mainAxisSpacing: 20.h,
                        ),
                        itemCount: list?.length ?? model.albumList.length,
                        itemBuilder: (__, index) {
                          Album album = list == null
                              ? model.albumList[index]
                              : list![index];
                          return MediaInfoCard(
                            onTap: () => model.onTap(album),
                            title: album.title,
                            subTitle: "${album.numberOfSongs} song" +
                                (album.numberOfSongs > 1 ? "s" : ""),
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
