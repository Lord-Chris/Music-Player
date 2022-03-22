import 'package:flutter/material.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/models/track.dart';
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
          child: Column(
            children: [
              AppHeader(
                pageTitle: "Favorites",
                image: AppAssets.favoritesHeader,
                searchLabel: "Search favorites",
                onFieldTap: model.onSearchTap,
              ),
              Expanded(
                child: StreamBuilder<List<Track>>(
                  initialData: model.favorites,
                  stream: model.streamFavorites(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'You don\'t have any favorite song',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2?.color,
                            fontSize: 20,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        controller: _controller,
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (__, index) {
                          Track music = snapshot.data![index];
                          return MyMusicCard(
                            music: music,
                            listId: FAVORITES,
                          );
                        },
                      );
                    }
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
