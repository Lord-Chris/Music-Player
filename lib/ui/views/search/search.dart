import 'package:flutter/material.dart';
import 'package:musicool/ui/constants/colors.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/views/search/search_model.dart';
import 'package:musicool/ui/views/albums/albums.dart';
import 'package:musicool/ui/views/artists/artists.dart';
import 'package:musicool/ui/shared/size_config.dart';
import 'package:musicool/ui/widget/music_bar.dart';
import 'package:musicool/ui/widget/music_card.dart';

class Search extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  // final List<Widget> tabs = [Songs(), Artists(), Albums()];
  final List<String> tabsName = ['Songs', 'Artists', 'Albums'];

  Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SearchModel>(
      builder: (context, model, child) {
        return DefaultTabController(
          length: tabsName.length,
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              toolbarHeight: 130,
              actions: [
                const Spacer(),
                Flexible(
                  flex: 7,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: SizeConfig.yMargin(context, 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  style: TextStyle(
                                    fontSize: SizeConfig.textSize(context, 4),
                                  ),
                                  onChanged: (val) => model.onChanged(
                                      _controller.text.toLowerCase()),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16),
                                    hintText: 'Enter KeyWord',
                                    fillColor: Theme.of(context).primaryColor,
                                    filled: true,
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        _controller.clear();
                                      },
                                      child: const Icon(Icons.cancel),
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
                tabs: tabsName.map((name) => Text(name)).toList(),
                indicatorWeight: SizeConfig.yMargin(context, 0.3),
                indicatorColor: ThemeColors.kPrimary,
                labelPadding: EdgeInsets.symmetric(
                    vertical: SizeConfig.yMargin(context, 1)),
                labelColor: Theme.of(context).textTheme.bodyText2?.color,
                labelStyle: TextStyle(
                  fontSize: SizeConfig.textSize(context, 5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: Container(
              color: Theme.of(context).backgroundColor,
              child: TabBarView(
                children: [
                  model.songs.isEmpty // || _controller.text.isEmpty)
                      ? Container()
                      : ListView.builder(
                          itemCount: model.songs.length,
                          itemBuilder: (__, index) {
                            return MyMusicCard(
                              music: model.songs[index],
                            );
                          }),
                  model.artists.isEmpty // || _controller.text.isEmpty)
                      ? Container()
                      : Artists(list: model.artists),
                  model.albums.isEmpty // || _controller.text.isEmpty)
                      ? Container()
                      : Albums(list: model.albums),
                ],
              ),
            ),
            bottomNavigationBar: const MyMusicBar(),
          ),
        );
      },
    );
  }
}
