


import 'package:authenticationapp/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String title;
  final bool isSelected;

  const CategoryChip(
    this.title,
    this.isSelected, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.red.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isSelected ? AppColors.red : AppColors.border,
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          color: isSelected ? AppColors.red : Colors.white70,
        ),
      ),
    );
  }
}