import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';

class MyBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(),
          ListTile(
            leading: Icon(
              MdiIcons.heart,
              size: SizeConfig.textSize(context, 6),
              color:
                  // model.checkFav()
                  //     ? Theme.of(context).accentColor
                  //     :
                  Theme.of(context).primaryColor,
            ),
            title: Text('Add to Favorite'),
          ),
          ListTile(
            leading: Icon(
              MdiIcons.share,
              size: SizeConfig.textSize(context, 6),
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Add to Favorite'),
          ),
          ListTile(
            leading: Icon(
              MdiIcons.heart,
              size: SizeConfig.textSize(context, 6),
              color:
                  // model.checkFav()
                  //     ? Theme.of(context).accentColor
                  //     :
                  Theme.of(context).primaryColor,
            ),
            title: Text('Add to Favorite'),
          ),
          ListTile(
            leading: Icon(
              MdiIcons.heart,
              size: SizeConfig.textSize(context, 6),
              color:
                  // model.checkFav()
                  //     ? Theme.of(context).accentColor
                  //     :
                  Theme.of(context).primaryColor,
            ),
            title: Text('Add to Favorite'),
          ),
        ],
      ),
    );
  }
}
