import 'package:flutter/material.dart';

class AppColors {
  static const blue = Color(0xFF36A8F4);
  static const grey = Color(0XFF635C5C);
}

class TextStyles {
  static TextStyle body = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 16.0, color: AppColors.grey);

  static TextStyle title = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 18.0, color: AppColors.grey);
}
