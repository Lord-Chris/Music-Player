import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:musicool/app/index.dart';

import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/favorites.dart';
import 'package:musicool/ui/shared/_shared.dart';
import 'package:musicool/ui/views/albums/albums.dart';
import 'package:musicool/ui/views/artists/artists.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/views/home/home.dart';
import 'package:musicool/ui/views/songs/songs.dart';

import '../_widgets.dart';

class AppDrawer<T extends Widget> extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(T);
    return BaseView<AppDrawerModel>(
      builder: (context, model, child) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.horizontal(right: Radius.circular(70)),
          ),
          clipBehavior: Clip.hardEdge,
          child: Drawer(
            backgroundColor: AppColors.darkMain,
            child: ListView(
              children: [
                const YMargin(100),
                const AppIcon(size: 25),
                const YMargin(100),
                Visibility(
                  visible: model.nowPlaying != null,
                  child: ListTile(
                    leading: SvgPicture.asset(
                      AppAssets.drawerHome,
                      color: T == HomeView ? AppColors.white : AppColors.grey,
                    ),
                    title: Text(
                      'Home',
                      style: kBodyStyle.copyWith(
                        color: T == HomeView ? AppColors.white : AppColors.grey,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => model.navigateTo(Routes.homeRoute),
                  ),
                ),
                const YMargin(20),
                ListTile(
                  leading: SvgPicture.asset(
                    AppAssets.drawerSongs,
                    color: T == SongsView ? AppColors.white : AppColors.grey,
                  ),
                  title: Text(
                    'Songs',
                    style: kBodyStyle.copyWith(
                      color: T == SongsView ? AppColors.white : AppColors.grey,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => model.navigateTo(Routes.songsRoute),
                ),
                const YMargin(20),
                ListTile(
                  leading: CircleAvatar(
                    radius: 13,
                    backgroundColor:
                        T == AlbumsView ? AppColors.white : AppColors.grey,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor: AppColors.darkMain,
                      child: Icon(
                        Icons.circle,
                        size: 5,
                        color:
                            T == AlbumsView ? AppColors.white : AppColors.grey,
                      ),
                    ),
                  ),
                  title: Text(
                    'Albums',
                    style: kBodyStyle.copyWith(
                      color: T == AlbumsView ? AppColors.white : AppColors.grey,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => model.navigateTo(Routes.albumsRoute),
                ),
                const YMargin(20),
                ListTile(
                  leading: SvgPicture.asset(
                    AppAssets.drawerArtist,
                    color: T == ArtistsView ? AppColors.white : AppColors.grey,
                  ),
                  title: Text(
                    'Artists',
                    style: kBodyStyle.copyWith(
                      color:
                          T == ArtistsView ? AppColors.white : AppColors.grey,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => model.navigateTo(Routes.artistsRoute),
                ),
                const YMargin(20),
                ListTile(
                  leading: SvgPicture.asset(
                    AppAssets.drawerFavorites,
                    color:
                        T == FavoritesView ? AppColors.white : AppColors.grey,
                  ),
                  title: Text(
                    'Favorites',
                    style: kBodyStyle.copyWith(
                      color:
                          T == FavoritesView ? AppColors.white : AppColors.grey,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => model.navigateTo(Routes.favoritesRoute),
                ),
                const YMargin(50),
                InkWell(
                  onTap: ()=> model.navigateBack(),
                  child: const CircleAvatar(
                    backgroundColor: AppColors.white,
                    radius: 35,
                    child: Icon(
                      Icons.close,
                      size: 25,
                      color: AppColors.darkMain,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
