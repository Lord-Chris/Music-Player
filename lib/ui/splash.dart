import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/music.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
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
    if (_sharedPrefs.musicList == null) {
      await _music.setupLibrary();
    }
    _music.setupLibrary();
    await Future.delayed(Duration(seconds: 4));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  void initState() {
    loading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
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
                    parentColor: Theme.of(context).backgroundColor,
                    color: Theme.of(context).accentColor,
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
