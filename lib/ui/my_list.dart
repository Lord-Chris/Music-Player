import 'package:flutter/material.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/view_models/my_list_model.dart';
import 'package:music_player/ui/base_view.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';
import 'package:music_player/ui/widget/music_bar.dart';
import 'package:music_player/ui/widget/music_card.dart';

import 'constants/colors.dart';

class MyList extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  final List<Track> list;
  final String pageTitle;

  MyList({Key key, this.list, this.pageTitle}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseView<MyListModel>(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: kbgColor,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              pageTitle,
              style: TextStyle(
                color: kSecondary,
              ),
            ),
          ),
          body: ListView.builder(
            controller: _controller,
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (__, index) {
              Track music = list[index];
              return MyMusicCard(
                music: music,
                list: list,
              );
            },
          ),
          bottomNavigationBar: MyMusicBar(),
        );
      },
    );
  }
}
