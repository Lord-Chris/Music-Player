import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:musicool/app/locator.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/core/utils/files_utils.dart';
import 'package:musicool/ui/components/_components.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';
// import 'package:musicool/ui/shared/size_config.dart';

class MyBottomSheet extends StatelessWidget {
  final _music = locator<IAudioFileService>();
  final Track track;

  MyBottomSheet({Key? key, required this.track}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FileUtils _utils = FileUtils(track);
    return Container(
      color: AppColors.main,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const YMargin(10),
          Center(
            child: Container(
              height: 4,
              width: 50,
              color: AppColors.white,
            ),
          ),
          const YMargin(5),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Row(
              children: [
                MediaArt(
                  art: track.artwork,
                  size: 50,
                  borderRadius: 10,
                ),
                const XMargin(20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const YMargin(2),
                      Text(
                        '${track.title}',
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: AppColors.white,
                        ),
                      ),
                      const YMargin(2),
                      Text(
                        '${track.artist}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const XMargin(20),
                Text(
                  track.toTime(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: AppColors.white,
                  ),
                ),
                const XMargin(10),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _music.setFavorite(track);
                  },
                  icon: Icon(
                    track.isFavorite ? MdiIcons.heart : MdiIcons.heartOutline,
                    size: 30,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.white),
          ListTile(
            leading: const Icon(
              Icons.play_arrow,
              size: 30,
              color: AppColors.white,
            ),
            title: const Text(
              'Play next',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: AppColors.white,
              ),
            ),
            onTap: () {
              // Navigator.pop(context);
              // _utils.share();
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.share,
              size: 25,
              color: AppColors.white,
            ),
            title: const Text(
              'Share',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: AppColors.white,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _utils.share();
            },
          ),
          ListTile(
            leading: SvgPicture.asset(AppAssets.properties, height: 18),
            title: const Text(
              'Properties',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: AppColors.white,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                clipBehavior: Clip.hardEdge,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                builder: (__) => MyPropertiesDialog(track: track),
              );
            },
          ),
          // ListTile(
          //   leading: Icon(
          //     MdiIcons.pencil,
          //     size: SizeConfig.textSize(context, 6),
          //     color: Theme.of(context).colorScheme.secondary,
          //   ),
          //   title: Text('Rename'),
          //   onTap: () {
          //     print(track.displayName);
          //     _utils.rename('stuff');
          //   },
          // ),
          // ListTile(
          //   leading: Icon(
          //     MdiIcons.trashCan,
          //     size: SizeConfig.textSize(context, 6),
          //     color: Theme.of(context).colorScheme.secondary,
          //   ),
          //   title: Text('Delete'),
          // ),
        ],
      ),
    );
  }
}

class MyPropertiesDialog extends StatelessWidget {
  const MyPropertiesDialog({
    Key? key,
    required this.track,
  }) : super(key: key);

  final Track track;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.main,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const YMargin(10),
          Center(
            child: Container(
              height: 4,
              width: 50,
              color: AppColors.white,
            ),
          ),
          const YMargin(15),
          MediaArt(
            art: track.artwork,
            size: 80,
            borderRadius: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Artist: ',
                        style: TextStyle(
                          color: AppColors.white,
                        ),
                      ),
                      TextSpan(
                        text: track.artist,
                        style: const TextStyle(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const YMargin(10),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Duration: ',
                        style: TextStyle(
                          color: AppColors.white,
                        ),
                      ),
                      TextSpan(
                        text: track.toTime(),
                        style: const TextStyle(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const YMargin(10),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Size: ',
                        style: TextStyle(
                          color: AppColors.white,
                        ),
                      ),
                      TextSpan(
                        text: track.toSize(),
                        style: const TextStyle(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const YMargin(10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location: ',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        track.filePath!,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
