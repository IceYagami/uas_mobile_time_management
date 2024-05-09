import 'package:flutter/material.dart';

class AppColors {
  static const darkgrey = Color(0XFF635C5C);
  static const darkblue = Color(0XFF0B6EFE);
}

class TextStyles {
  static TextStyle title = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 18.0, color: AppColors.darkgrey);

  static TextStyle body = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 16.0, color: AppColors.darkgrey);
}
