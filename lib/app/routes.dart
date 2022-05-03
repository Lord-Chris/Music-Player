import 'package:flutter/material.dart';
import 'package:musicool/ui/views/albums/albums.dart';
import 'package:musicool/ui/views/artists/artists.dart';
import 'package:musicool/ui/views/favourites/favourites.dart';
import 'package:musicool/ui/views/home/home.dart';
import 'package:musicool/ui/views/my_list/my_list.dart';
import 'package:musicool/ui/views/search/search.dart';
import 'package:musicool/ui/views/songs/songs.dart';
import 'package:musicool/ui/views/splash/splash.dart';

class Routes {
  static const splashRoute = '/';
  static const homeRoute = '/home';
  static const songsRoute = '/songs';
  static const albumsRoute = '/albums';
  static const artistsRoute = '/artists';
  static const favouritesRoute = '/favourites';
  static const songGroupRoute = '/song_group';
  static const searchRoute = '/search';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case songsRoute:
        return MaterialPageRoute(builder: (_) => SongsView());
      case albumsRoute:
        return MaterialPageRoute(builder: (_) => const AlbumsView());
      case artistsRoute:
        return MaterialPageRoute(builder: (_) => const ArtistsView());
      case favouritesRoute:
        return MaterialPageRoute(builder: (_) => FavouritesView());
      case songGroupRoute:
        var data = settings.arguments as List;
        return MaterialPageRoute(
          builder: (_) => SongGroupList(
            list: data[0],
            songGroup: data[1],
          ),
        );
      case searchRoute:
        var data = settings.arguments;
        return MaterialPageRoute(builder: (_) => SearchView(type: data));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
