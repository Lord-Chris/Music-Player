import 'package:musicool/app/index.dart';
import 'package:musicool/ui/constants/colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    required this.searchLabel,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.onChanged,
    this.onTap,
    this.enabled = false,
  }) : super(key: key);

  final String searchLabel;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: TextField(
        enabled: enabled,
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          color: AppColors.darkMain,
          fontSize: 10.sp,
          height: 1.21,
        ),
        decoration: InputDecoration(
          fillColor: const Color.fromRGBO(244, 185, 255, 0.86),
          filled: true,
          hintText: searchLabel,
          hintStyle: TextStyle(
            color: const Color.fromRGBO(4, 72, 72, 0.8),
            fontSize: 10.sp,
            height: 1.21,
            fontWeight: FontWeight.normal,
          ),
          contentPadding: const EdgeInsets.only(left: 15),
          constraints: BoxConstraints.tight(
            Size.fromHeight(28.h),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
