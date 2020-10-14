import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/view_models/albums_model.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';
import 'package:music_player/ui/widget/my_list.dart';

import 'base_view.dart';
import 'constants/colors.dart';

class Albums extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<AlbumsModel>(
      builder: (context, model, child) {
        print(model.albumList.length);
        return Container(
          height: SizeConfig.yMargin(context, 24),
          padding:
              EdgeInsets.fromLTRB(0, SizeConfig.yMargin(context, 15), 0, 0),
          child: GridView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.xMargin(context, 3),
            ),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: SizeConfig.xMargin(context, 40),
              childAspectRatio: SizeConfig.textSize(context, 0.16),
              crossAxisSpacing: SizeConfig.xMargin(context, 2),
              mainAxisSpacing: SizeConfig.yMargin(context, 1),
            ),
            itemCount: model.albumList.length,
            itemBuilder: (__, index) {
              return Container(
                // color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        List<Track> response = await model.onTap(index);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                body: Container(
                                  width: SizeConfig.xMargin(context, 100),
                                  height: SizeConfig.xMargin(context, 100),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      MyList(
                                        false,
                                        list: response,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      },
                      child: model.albumList[index].albumArt == null
                          ? Container(
                              width: SizeConfig.xMargin(context, 30),
                              height: SizeConfig.xMargin(context, 30),
                              decoration: BoxDecoration(
                                color: kPrimary,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/placeholder_image.png'),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            )
                          : Container(
                              width: SizeConfig.xMargin(context, 30),
                              height: SizeConfig.xMargin(context, 30),
                              decoration: BoxDecoration(
                                color: kPrimary,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                image: DecorationImage(
                                  image: FileImage(
                                      File(model.albumList[index].albumArt)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: SizeConfig.yMargin(context, 1),
                    ),
                    Text(
                      model.albumList[index].title,
                      maxLines: 2,
                      style: TextStyle(
                        color: kBlack,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.yMargin(context, 0.5),
                    ),
                    Text(
                      model.albumList[index].numberOfSongs,
                      style: TextStyle(
                        color: kBlack,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
