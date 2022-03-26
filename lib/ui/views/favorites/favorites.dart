import 'package:musicool/app/index.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/ui/components/_components.dart';
import 'package:musicool/ui/shared/_shared.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/views/favorites/favorites_model.dart';
import 'package:musicool/ui/widget/music_card.dart';

import '../../constants/_constants.dart';

class FavoritesView extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  FavoritesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<FavoritesModel>(
      builder: (context, model, child) {
        return AppBaseView<FavoritesView>(
          child: StreamBuilder<List<Track>>(
            initialData: model.favorites,
            stream: model.streamFavorites(),
            builder: (context, snapshot) {
              return Column(
                children: [
                  AppHeader(
                    pageTitle: "Favorites",
                    image: AppAssets.favoritesHeader,
                    searchLabel: "Search favorites",
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
                        icon: const Icon(Icons.delete_outline_rounded),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Visibility(
                      visible: snapshot.data!.isEmpty,
                      child: const Center(
                        child: Text(
                          'No songs here 😟',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      replacement: ListView.builder(
                        controller: _controller,
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (__, index) {
                          Track music = snapshot.data![index];
                          return MyMusicCard(
                            music: music,
                            onTap: () => model.onTrackTap(music, FAVORITES),
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
