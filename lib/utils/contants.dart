import 'dart:ui';

import 'package:get/get.dart';

import '../controller/theme_controller.dart';

const kategoriItem = ['Me Time', 'Work', 'Study'];
const reminderItem = [5, 10, 15, 30];

Color createThemeColorSchema(
    {required Color lightColor, required Color darkColor}) {
  return Get.find<ThemeController>().isDarkMode() ? darkColor : lightColor;
}
