import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/ui/components/_components.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:provider/provider.dart';

class PlayingArtView extends StatelessWidget {
  final List<Track> list;
  const PlayingArtView({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _track = Provider.of<Track>(context);
    final _index = list.indexOf(_track);
    final _beforeIndex = _index - 1 < 0 ? list.length - 1 : _index - 1;
    final _afterIndex = _index + 1 == list.length ? 0 : _index + 1;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 450,
      child: Stack(
        children: [
          Positioned(
            left: -320,
            child: PlayingArt(art: list[_beforeIndex].artwork),
          ),
          Positioned(
            child: Center(
              child: PlayingArt(art: list[_index].artwork),
            ),
          ),
          Positioned(
            right: -320,
            child: PlayingArt(art: list[_afterIndex].artwork),
          ),
        ],
      ),
    );
  }
}

class PlayingArt extends StatelessWidget {
  final Uint8List? art;
  const PlayingArt({
    Key? key,
    required this.art,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKeys.NOWPLAYING,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      clipBehavior: Clip.hardEdge,
      height: 450,
      width: 350,
      child: Stack(
        fit: StackFit.expand,
        children: [
          MediaArt(
            art: art,
            defArtSize: 200,
          ),
          Positioned(
            top: -60,
            child: ClipOval(
              clipBehavior: Clip.hardEdge,
              child: Container(
                height: 100,
                width: 190,
                color: AppColors.white,
              ),
            ),
          ),
          Positioned(
            bottom: -75,
            left: 0,
            right: 0,
            child: Center(
              child: ClipOval(
                clipBehavior: Clip.hardEdge,
                child: Container(
                  height: 100,
                  width: 169,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
