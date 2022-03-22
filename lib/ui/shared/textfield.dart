import 'package:flutter/material.dart';
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
        style: const TextStyle(
          color: AppColors.darkMain,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          fillColor: const Color.fromRGBO(244, 185, 255, 0.86),
          filled: true,
          hintText: searchLabel,
          hintStyle: const TextStyle(
            color: Color.fromRGBO(4, 72, 72, 0.8),
            fontSize: 15,
          ),
          contentPadding: const EdgeInsets.only(left: 15),
          constraints: BoxConstraints.tight(
            const Size.fromHeight(40),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
