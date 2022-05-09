import 'package:musicool/app/index.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/ui/components/_components.dart';
import 'package:musicool/ui/shared/_shared.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/views/favourites/favourites_model.dart';
import 'package:musicool/ui/widget/music_card.dart';

import '../../constants/_constants.dart';

class FavouritesView extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  FavouritesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<FavouritesModel>(
      builder: (context, model, child) {
        return AppBaseView<FavouritesView>(
          child: StreamBuilder<List<Track>>(
            initialData: model.favourites,
            stream: model.streamfavourites(),
            builder: (context, snapshot) {
              return Column(
                children: [
                  AppHeader(
                    pageTitle: "Favourites",
                    image: AppAssets.favouritesHeader,
                    searchLabel: "Search favourites",
                    onFieldTap: model.onSearchTap,
                    suffixWidget: Visibility(
                      visible: snapshot.data!.isNotEmpty,
                      child: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            clipBehavior: Clip.hardEdge,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(50),
                              ),
                            ),
                            builder: (_) => DeleteBottomSheet(
                              onNoTap: () => model.navigateBack(),
                              onYesTap: () => model.removeAllFavourites(),
                            ),
                          );
                        },
                        iconSize: 20.sp,
                        color: AppColors.white,
                        icon: const Icon(Icons.delete_outline_rounded),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Visibility(
                      visible: snapshot.data!.isEmpty,
                      child: Center(
                        child: Text(
                          "No favourites found",
                          style: kSubBodyStyle.copyWith(fontSize: 16.sm),
                        ),
                      ),
                      replacement: ListView.builder(
                        controller: _controller,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 100.h),
                        itemCount: snapshot.data?.length ?? 0,
                        itemExtent: 60.h,
                        itemBuilder: (__, index) {
                          Track music = snapshot.data![index];
                          return MyMusicCard(
                            music: music,
                            onTap: () => model.onTrackTap(music, FAVOURITES),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
