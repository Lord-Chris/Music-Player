import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/app/locator.dart';
import 'package:music_player/ui/constants/colors.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';
import 'package:music_player/ui/views/base_view/base_view.dart';
import 'package:music_player/ui/views/splash/splash_model.dart';

import '../../widget/icon.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  myAlertBox() async => await showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(SizeConfig.textSize(context, 3)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(SizeConfig.textSize(context, 3)),
                  child: Text(
                    'Musicool needs storage permission to work',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2?.color,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.textSize(context, 5),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Divider(color: ThemeColors.kPrimary),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    locator<SplashModel>().loading(context, myLoadingBox, myAlertBox);
                    // setState(()=>);?
                  },
                  child: Container(
                    width: SizeConfig.xMargin(context, 80),
                    padding: EdgeInsets.all(SizeConfig.textSize(context, 2)),
                    child: Text(
                      'Accept permission',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textSize(context, 5),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
  myLoadingBox() async => await showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(SizeConfig.textSize(context, 4)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                // SizedBox(height: SizeConfig.yMargin(context, 1)),
                Container(
                  padding: EdgeInsets.all(SizeConfig.textSize(context, 4)),
                  child: Text(
                    'Loading ...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2?.color,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.textSize(context, 5),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BaseView<SplashModel>(
      onModelReady: (model) {
        model.loading(context, myLoadingBox, myAlertBox);
      },
      builder: (context, model, child) {
        return Scaffold(
          body: Container(
            color: Theme.of(context).accentColor,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: MyIcon(),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Center(
                      child: ClayText(
                        'Musicool',
                        parentColor: Theme.of(context).accentColor,
                        color: ThemeColors.kLightBg,
                        style: TextStyle(
                          fontSize: SizeConfig.textSize(context, 10),
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
