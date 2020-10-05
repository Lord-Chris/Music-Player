import 'package:flutter/material.dart';
import 'package:music_player/core/view_models/songs_model.dart';
import 'package:music_player/ui/widget/music_card.dart';
import 'package:music_player/ui/widget/my_list.dart';

import 'base_view.dart';
import 'constants/colors.dart';
import 'shared/sizeConfig.dart';

class Songs extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  final bool showRecent = true;
  @override
  Widget build(BuildContext context) {
    return BaseView<SongsModel>(
      builder: (context, model, child) {
        return Positioned(
          top: SizeConfig.yMargin(context, 15),
          right: 0,
          left: 0,
          child: Container(
            color: kbgColor,
            height: SizeConfig.yMargin(context, 82),
            width: SizeConfig.xMargin(context, 100),
            child: ListView(
              controller: _controller,
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: SizeConfig.yMargin(context, 1),
                ),
                showRecent
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.xMargin(context, 3),
                        ),
                        child: Text(
                          'Recently Played',
                          style: TextStyle(
                            color: kBlack,
                            fontSize: SizeConfig.textSize(context, 5),
                          ),
                        ),
                      )
                    : Container(),
                showRecent
                    ? SizedBox(
                        height: SizeConfig.yMargin(context, 2),
                      )
                    : Container(),
                showRecent
                    ? Container(
                        height: SizeConfig.yMargin(context, 24),
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.xMargin(context, 3),
                          ),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          separatorBuilder: (__, index) => Padding(
                              padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.xMargin(context, 2),
                          )),
                          itemBuilder: (__, index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: SizeConfig.xMargin(context, 30),
                                  height: SizeConfig.yMargin(context, 17),
                                  decoration: BoxDecoration(
                                    color: kPrimary,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.yMargin(context, 1),
                                ),
                                Text(
                                  'Title',
                                  style: TextStyle(
                                    color: kBlack,
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.yMargin(context, 0.5),
                                ),
                                Text(
                                  'Artist',
                                  style: TextStyle(
                                    color: kBlack,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    : Container(),
                showRecent
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.xMargin(context, 3),
                        ),
                        child: Text(
                          'All Songs',
                          style: TextStyle(
                            color: kBlack,
                            fontSize: SizeConfig.textSize(context, 5),
                          ),
                        ),
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.xMargin(context, 3),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: model.musicList.map<Widget>((music) {
                      return MyMusicCard(
                        music: music,
                        index: model.musicList.indexOf(music),
                        list: model.musicList,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
