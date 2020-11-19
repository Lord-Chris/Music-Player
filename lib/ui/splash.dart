import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/utils/music_util.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/constants/colors.dart';
import 'package:music_player/ui/shared/sizeConfig.dart';

import 'home.dart';
import 'widget/icon.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  Music _music = locator<Music>();

  void loading() async {
    bool isReady = false;
    bool isLoading = false;
    if (_sharedPrefs.musicList.isEmpty) {
      isLoading = await _music.getPermissions();
      if (isLoading) {
        myLoadingBox();
        print('waiting ....');
        isReady = await _music.setupLibrary();
      }
    } 
    else {
      _music.setupLibrary();
      await Future.delayed(Duration(seconds: 3));
      setState(() => isReady = true);
      print('using delay ....');
    }

    if (isReady)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });
    else {
      myAlertBox();
    }
  }

  myAlertBox() => showDialog(
        context: context,
        child: Dialog(
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
                      color: Theme.of(context).textTheme.bodyText2.color,
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
                    loading();
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
  myLoadingBox() => showDialog(
        context: context,
        child: Dialog(
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
                      color: Theme.of(context).textTheme.bodyText2.color,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.textSize(context, 5),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                // Divider(color: ThemeColors.kPrimary),
                // InkWell(
                //   onTap: () {
                //     Navigator.pop(context);loading();
                //     // setState(()=>);?
                //   },
                //   child: Container(
                //     width: SizeConfig.xMargin(context, 80),
                //     padding: EdgeInsets.all(SizeConfig.textSize(context, 2)),
                //     child: Text(
                //       'Accept permission',
                //       textAlign: TextAlign.center,
                //       style: TextStyle(
                //         color: Theme.of(context).accentColor,
                //         fontWeight: FontWeight.bold,
                //         fontSize: SizeConfig.textSize(context, 5),
                //         fontStyle: FontStyle.italic,
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      );

  @override
  void initState() {
    loading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // loading();
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
                    color: Theme.of(context).backgroundColor,
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
  }
}
