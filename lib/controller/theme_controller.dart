import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uts_mobile/style.dart';

class ThemeController extends GetxController {
  late final GetStorage storeTheme;

  final _themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    storeTheme = GetStorage();

    String? getTheme = storeTheme.read("theme");

    if (getTheme != null) {
      setThemeData(parseThemeMode(getTheme));
    }
  }

  ThemeData get darkMode => ThemeData(
        dropdownMenuTheme: const DropdownMenuThemeData(
          textStyle: TextStyle(color: Colors.white),
        ),
        colorScheme: const ColorScheme.dark(
          brightness: Brightness.light,
          primary: AppColors.blue,
          secondary: Colors.pink,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
        ),
        dividerColor: Colors.transparent,
      );

  ThemeData get lightMode => ThemeData(
        dropdownMenuTheme: const DropdownMenuThemeData(
          textStyle: TextStyle(color: Colors.black),
        ),
        colorScheme: const ColorScheme.light(
          brightness: Brightness.dark,
          primary: AppColors.blue,
          secondary: Colors.pink,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
        ),
        dividerColor: Colors.transparent,
      );

  Rx<ThemeMode> get themeMode => _themeMode;

  Rx<ThemeData> get currentTheme {
    switch (_themeMode.value) {
      case ThemeMode.light:
        return lightMode.obs;
      case ThemeMode.dark:
        return darkMode.obs;
      default:
        return lightMode.obs;
    }
  }

  RxBool get isDarkMode => (_themeMode.value == ThemeMode.dark).obs;

  void setThemeData(ThemeMode themeMode) {
    _themeMode.value = themeMode;
    _setStoreTheme(themeMode);
    _setUIColor();
  }

  ThemeMode parseThemeMode(String themeString) {
    switch (themeString) {
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void _setUIColor() {
    ThemeData theme = currentTheme();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: theme.appBarTheme.backgroundColor,
        statusBarIconBrightness: theme.colorScheme.brightness,
        statusBarBrightness: theme.colorScheme.brightness,
        systemNavigationBarColor:
            theme.bottomNavigationBarTheme.backgroundColor,
        systemNavigationBarIconBrightness: theme.colorScheme.brightness,
      ),
    );
  }

  void _setStoreTheme(ThemeMode themeMode) {
    storeTheme.write("theme", themeMode.toString().split('.').last);
  }

  Color get hintCustomColor {
    return _themeMode.value == ThemeMode.dark ? Colors.white : Colors.black;
  }
}
