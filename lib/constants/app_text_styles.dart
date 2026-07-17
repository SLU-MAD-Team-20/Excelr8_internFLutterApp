import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const heading = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );

  static const button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
}