import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/spacings.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/views/splash/splash_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Future<void> showPermissionDialog(SplashModel model) async =>
      await showModalBottomSheet(
        context: context,
        clipBehavior: Clip.hardEdge,
        isDismissible: false,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (context) => PermissionSheet(
          onYesTap: () {
            model.navigateBack();
            model.initializeApp();
          },
          onNoTap: () => model.closeApp(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BaseView<SplashModel>(
      onModelReady: (model) {
        WidgetsBinding.instance!.addPostFrameCallback((_) async {
          if (await model.showPermissionSheet()) {
            showPermissionDialog(model);
          } else {
            model.initializeApp();
          }
        });
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: AppColors.darkMain,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      // child: Image.asset(AppAssets.appIcon),
                      child: CircleAvatar(
                        radius: 43.r,
                        backgroundColor: AppColors.white,
                        child: CircleAvatar(
                          radius: 25.r,
                          backgroundColor: AppColors.lightMain,
                          child: Icon(
                            Icons.play_arrow_rounded,
                            size: 38.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    const YMargin(10),
                    Center(
                      child: Text(
                        'Musicool',
                        style: TextStyle(
                          fontFamily: "House Music",
                          fontSize: 30.sm,
                          height: 1.15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 40.h,
                left: 0,
                right: 0,
                child: Visibility(
                  visible: model.loadingText.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoActivityIndicator(
                        radius: 15.sp,
                        // color: AppColors.white,
                      ),
                      const YMargin(10),
                      Text(
                        model.loadingText,
                        style: kBodyStyle.copyWith(
                          color: AppColors.white,
                          // fontFamily: "House Music",
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PermissionSheet extends StatelessWidget {
  final VoidCallback onYesTap;
  final VoidCallback onNoTap;

  const PermissionSheet({
    Key? key,
    required this.onYesTap,
    required this.onNoTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        color: AppColors.main,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const YMargin(10),
            Center(
              child: Container(
                height: 5.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),
            const YMargin(25),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    "Musicool needs your permission to access to your music library.\n\n\nAllow?",
                    style: kBodyStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            const YMargin(25),
            ButtonBar(
              children: [
                TextButton(
                  onPressed: onYesTap,
                  child: Text(
                    "Yes",
                    style: TextStyle(
                      color: AppColors.main,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) => AppColors.white),
                  ),
                ),
                const XMargin(30),
                TextButton(
                  onPressed: onNoTap,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                      (states) => const RoundedRectangleBorder(
                        side: BorderSide(color: AppColors.white),
                      ),
                    ),
                  ),
                  child: Text(
                    "No",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const YMargin(15),
          ],
        ),
      ),
    );
  }
}
