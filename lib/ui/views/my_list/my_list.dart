import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/ui/components/_components.dart';
import 'package:musicool/ui/constants/app_assets.dart';

import 'package:musicool/ui/constants/colors.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/views/my_list/my_list_model.dart';
import 'package:musicool/ui/widget/music_card.dart';

class SongGroupList extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  final List<Track>? list;
  final dynamic songGroup;

  SongGroupList({
    Key? key,
    this.list,
    required this.songGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _isAlbum = songGroup.runtimeType == Album;

    return BaseView<SongGroupListModel>(
      builder: (context, model, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: Column(
              children: [
                Container(
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(80),
                    ),
                    image: songGroup.artwork == null
                        ? const DecorationImage(
                            image: AssetImage(AppAssets.defaultArt),
                          )
                        : DecorationImage(
                            image: MemoryImage(songGroup.artwork),
                            fit: BoxFit.cover,
                          ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      color: AppColors.black.withOpacity(0.1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () => model.navigateBack(),
                            icon: const Icon(Icons.chevron_left),
                            iconSize: 35,
                          ),
                          Center(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: MediaArt(
                                art: songGroup.artwork,
                                defArtSize: 5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _controller,
                    shrinkWrap: true,
                    itemCount: list?.length,
                    itemBuilder: (__, index) {
                      Track music = list![index];
                      return MyMusicCard(
                        music: music,
                        listId: songGroup.id,
                      );
                    },
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
