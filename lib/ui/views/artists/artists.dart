import 'package:flutter/material.dart';
import 'package:musicool/core/models/artists.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'artists_model.dart';

class ArtistsView extends StatelessWidget {
  final List<Artist>? list;

  const ArtistsView({Key? key, this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _deviceWidth = MediaQuery.of(context).size.width;
    final _deviceHeight = MediaQuery.of(context).size.height;
    return BaseView<ArtistsModel>(
      builder: (context, model, child) {
        return AppBaseView<ArtistsView>(
          child: Column(
            children: [
              const AppHeader(
                pageTitle: "Artists",
                image: AppAssets.artistsHeader,
                searchLabel: "Search artists",
              ),
              Expanded(
                child: model.artistList.isEmpty
                    ? Center(
                        child: Text(
                          'No artists found',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2?.color,
                            fontSize: 20,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 50),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: _deviceWidth / _deviceHeight * 1.65,
                          crossAxisSpacing: (_deviceWidth * 0.03),
                          // (_deviceWidth %
                          //         (_deviceWidth / 3 - _deviceWidth * 0.1)) /
                          //     (_deviceWidth / (_deviceWidth / 3)),
                          mainAxisSpacing: 25,
                        ),
                        itemCount: list?.length ?? model.artistList.length,
                        itemBuilder: (__, index) {
                          Artist artist = list == null
                              ? model.artistList[index]
                              : list![index];
                          return InkWell(
                            onTap: () => model.onTap(artist),
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.main,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          child:
                                              // TODO: Refactor this
                                              artist.artwork == null
                                                  ? Center(
                                                      child: Image.asset(
                                                        AppAssets.defaultArt,
                                                        height: 70,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    )
                                                  : Image.memory(
                                                      artist.artwork!,
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (ctx, obj, tr) {
                                                        return Image.asset(
                                                          AppAssets.defaultArt,
                                                          height: 70,
                                                          fit: BoxFit.contain,
                                                        );
                                                      },
                                                    ),
                                        ),
                                        Positioned(
                                          bottom: -5,
                                          right: -5,
                                          child: PlayButton(
                                            size: 4,
                                            onTap: () {},
                                            showPause: false,
                                          ),
                                        ),
                                        Positioned(
                                          top: 15,
                                          right: 15,
                                          child: false
                                              // ignore: dead_code
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    child: Center(
                                                      child: Text(
                                                        "_item.duration!",
                                                        style: kLittleStyle,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const YMargin(10),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: Text(
                                      artist.name ?? "",
                                      style: kBodyStyle,
                                      maxLines: 1,
                                    ),
                                  ),
                                  const YMargin(5),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: Text(
                                      "${artist.numberOfSongs} song" +
                                          (artist.numberOfSongs! > 1
                                              ? "s"
                                              : ""),
                                      style: kSubBodyStyle,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
// if (model.artistList.isEmpty) {
//           return Center(
//             child: Text(
//               'No artists found.',
//               style: TextStyle(
//                 color: Theme.of(context).textTheme.bodyText2?.color,
//                 fontSize: 20,
//               ),
//             ),
//           );
//         }
//         return GridView.builder(
//           padding: EdgeInsets.all(SizeConfig.xMargin(context, 3)),
//           shrinkWrap: true,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3, //SizeConfig.xMargin(context, 10),
//             childAspectRatio: 0.7,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//           ),
//           itemCount: list?.length ?? model.artistList.length,
//           itemBuilder: (__, index) {
//             Artist artist =
//                 list == null ? model.artistList[index] : list![index];
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 InkWell(
//                   onTap: () async {
//                     List<Track> response = await model.onTap(artist);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => MyList(
//                           list: response,
//                           pageTitle: artist.name,
//                           listId: artist.name,
//                         ),
//                       ),
//                     );
//                   },
//                   child: ClayContainer(
//                     parentColor: Theme.of(context).backgroundColor,
//                     color: Theme.of(context).colorScheme.secondary,
//                     borderRadius: 20,
//                     width: SizeConfig.xMargin(context, 30),
//                     height: SizeConfig.xMargin(context, 30),
//                     curveType: CurveType.convex,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: const BorderRadius.all(Radius.circular(20)),
//                         image: artist.artwork == null
//                             ? const DecorationImage(
//                                 image: AssetImage(
//                                     'assets/placeholder_image.png'),
//                                 fit: BoxFit.scaleDown,
//                               )
//                             : DecorationImage(
//                                 image: MemoryImage(artist.artwork!),
//                                 fit: BoxFit.cover,
//                               ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: SizeConfig.yMargin(context, 1),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: SizeConfig.xMargin(context, 1)),
//                   child: Text(
//                     artist.name!,
//                     maxLines: 2,
//                     style: TextStyle(
//                       color: Theme.of(context).textTheme.bodyText2?.color,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: SizeConfig.yMargin(context, 0.5),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: SizeConfig.xMargin(context, 1)),
//                   child: Text(
//                     'Songs: ' + artist.numberOfSongs!.toString(),
//                     style: TextStyle(
//                       color: Theme.of(context)
//                           .textTheme
//                           .bodyText2
//                           ?.color
//                           ?.withOpacity(0.6),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },