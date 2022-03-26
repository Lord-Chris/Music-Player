import 'package:musicool/app/index.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';

class DeleteBottomSheet extends StatelessWidget {
  final VoidCallback onYesTap;
  final VoidCallback onNoTap;

  const DeleteBottomSheet({
    Key? key,
    required this.onYesTap,
    required this.onNoTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.main,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const YMargin(10),
          Center(
            child: Container(
              height: 5.h,
              width: 46.w,
              color: AppColors.white,
            ),
          ),
          const YMargin(25),
          Row(
            children: [
              Icon(
                Icons.delete_outline_rounded,
                size: 20.sp,
              ),
              Text(
                "Are you sure you want to delete all?",
                style: kBodyStyle.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          const YMargin(33),
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
        ],
      ),
    );
  }
}
