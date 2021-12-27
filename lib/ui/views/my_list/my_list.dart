import 'package:flutter/material.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/views/my_list/my_list_model.dart';
import 'package:musicool/ui/widget/music_bar.dart';
import 'package:musicool/ui/widget/music_card.dart';

class MyList extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  final List<Track>? list;
  final String? listId;
  final String? pageTitle;

  MyList({Key? key, this.list, this.listId, this.pageTitle}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseView<MyListModel>(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              pageTitle!,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText2?.color,
              ),
            ),
          ),
          body: ListView.builder(
            controller: _controller,
            shrinkWrap: true,
            itemCount: list?.length,
            itemBuilder: (__, index) {
              Track music = list![index];
              return MyMusicCard(
                music: music,
                listId: listId,
              );
            },
          ),
          bottomNavigationBar: MyMusicBar(),
        );
      },
    );
  }
}
