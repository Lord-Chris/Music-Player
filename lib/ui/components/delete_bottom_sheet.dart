
import 'package:flutter/material.dart';
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
              height: 4,
              width: 50,
              color: AppColors.white,
            ),
          ),
          const YMargin(25),
          Row(
            children: const [
              Icon(Icons.delete_outline_rounded),
              Text(
                "Are you sure you want to delete all?",
              ),
            ],
          ),
          const YMargin(33),
          ButtonBar(
            children: [
              TextButton(
                onPressed: onYesTap,
                child: const Text("Yes"),
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
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
