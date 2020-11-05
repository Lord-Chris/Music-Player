import 'package:flutter/material.dart';
import 'package:music_player/core/view_models/search_model.dart';
import 'package:music_player/ui/albums.dart';
import 'package:music_player/ui/artists.dart';
import 'package:music_player/ui/base_view.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';
import 'package:music_player/ui/widget/music_bar.dart';
import 'package:music_player/ui/widget/music_card.dart';

class Search extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  // final List<Widget> tabs = [Songs(), Artists(), Albums()];
  final List<String> tabsName = ['Songs', 'Artists', 'Albums'];

  @override
  Widget build(BuildContext context) {
    return BaseView<SearchModel>(builder: (context, model, child) {
      return DefaultTabController(
        length: tabsName.length,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            toolbarHeight: SizeConfig.yMargin(context, 14),
            actions: [
              Spacer(),
              Flexible(
                flex: 7,
                child: Row(
                  children: [
                    //TODO: cancel button removes when textfield is tapped
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: SizeConfig.yMargin(context, 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                style: TextStyle(
                                  fontSize: SizeConfig.textSize(context, 4),
                                ),
                                onChanged: (val) =>
                                    model.onChanged(_controller.text.toLowerCase()),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 16),
                                  hintText: 'Enter KeyWord',
                                  fillColor: Theme.of(context).primaryColor,
                                  filled: true,
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      _controller.clear();
                                    },
                                    child: Icon(Icons.cancel),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              tabs: tabsName
                  .map((name) => Container(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.yMargin(context, 1)),
                        child: Text(
                          name,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline1.color,
                            fontSize: SizeConfig.textSize(context, 5),
                          ),
                        ),
                      ))
                  .toList(),
              indicatorWeight: SizeConfig.yMargin(context, 0.3),
              labelPadding: EdgeInsets.symmetric(
                  vertical: SizeConfig.yMargin(context, 1)),
              labelColor: Theme.of(context).textTheme.headline1.color,
              labelStyle: TextStyle(
                fontSize: SizeConfig.textSize(context, 5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Container(
            color: Theme.of(context).backgroundColor,
            child: TabBarView(
              children: [
                model.songs == null // || _controller.text.isEmpty)
                    ? Container()
                    : ListView.builder(
                        itemCount: model.songs?.length,
                        itemBuilder: (__, index) {
                          return MyMusicCard(
                            music: model.songs[index],
                          );
                        }),
                model.artists == null // || _controller.text.isEmpty)
                    ? Container()
                    : Artists(list: model.artists),
                model.albums == null // || _controller.text.isEmpty)
                    ? Container()
                    : Albums(list: model.albums),
              ],
            ),
          ),
          bottomNavigationBar: MyMusicBar(),
        ),
      );
    });
  }
}
