import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';

import 'package:musicool/app/locator.dart';
import 'package:musicool/core/enums/view_state.dart';
import 'package:musicool/core/services/local_storage_service/i_local_storage_service.dart';
import 'package:musicool/ui/constants/colors.dart';
import 'package:musicool/ui/shared/size_config.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/views/home/home.dart';
import 'package:musicool/ui/views/splash/splash_model.dart';

import '../../widget/icon.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void showPermissionDialog() async => await showDialog(
        context: context,
        builder: (context) => ErrorDialog(
          body: 'Musicool needs access to your storage',
          negative: 'Decline',
          onNegative: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          positive: 'Accept',
          onPositive: () {
            Navigator.pop(context);
            locator<SplashModel>().initializeApp(
              onPermissionError: () => showPermissionDialog(),
              onLibraryError: () => showLibraryErrorDialog(),
              onSuccess: onSuccess,
            );
          },
        ),
      );
  showLibraryErrorDialog() async => await showDialog(
        context: context,
        builder: (context) => ErrorDialog(
          body: 'Error occured while fetching music ',
          negative: 'Exit',
          onNegative: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          positive: 'Try Again',
          onPositive: () {
            locator<ILocalStorageService>().clearBox();
            // locator<ILocalStorageService>().init();
            Navigator.pop(context);
            locator<SplashModel>().initializeApp(
              onPermissionError: () => showPermissionDialog(),
              onLibraryError: () => showLibraryErrorDialog(),
              onSuccess: onSuccess,
            );
          },
        ),
      );

  void onSuccess() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<SplashModel>(
      onModelReady: (model) {
        model.initializeApp(
          onPermissionError: () => showPermissionDialog(),
          onLibraryError: () => showLibraryErrorDialog(),
          onSuccess: onSuccess,
        );
        // Future.delayed(Duration(seconds: 3),()=> myAlertBox());
      },
      builder: (context, model, child) {
        return Scaffold(
          body: Container(
            color: Theme.of(context).colorScheme.secondary,
            child: Column(
              children: [
                const Expanded(
                  flex: 2,
                  child: Center(
                    child: MyIcon(),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: model.state == ViewState.busy,
                        child: const CircularProgressIndicator(
                          color: ThemeColors.klight,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ClayText(
                          'Musicool',
                          parentColor:
                              Theme.of(context).colorScheme.secondary,
                          color: ThemeColors.kLightBg,
                          style: TextStyle(
                            fontSize: SizeConfig.textSize(context, 10),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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

class ErrorDialog extends StatelessWidget {
  final String body;
  final String positive;
  final Function onPositive;
  final String negative;
  final Function onNegative;
  const ErrorDialog({
    Key? key,
    required this.body,
    required this.positive,
    required this.onPositive,
    required this.negative,
    required this.onNegative,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                body,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2?.color,
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.textSize(context, 5),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const Divider(
              color: ThemeColors.kPrimary,
              thickness: 1.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => onNegative(),
                    child: Container(
                      width: SizeConfig.xMargin(context, 80),
                      padding: EdgeInsets.all(SizeConfig.textSize(context, 2)),
                      child: Text(
                        negative,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.textSize(context, 5),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1.5,
                  height: 30,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => onPositive(),
                    child: Container(
                      width: SizeConfig.xMargin(context, 80),
                      padding: EdgeInsets.all(SizeConfig.textSize(context, 2)),
                      child: Text(
                        positive,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.textSize(context, 5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
