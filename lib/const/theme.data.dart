import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/const/app_color.dart';

class Styles {
  static ThemeData themeData(
      {required bool isDarkTheme, required BuildContext context}) {
    return ThemeData(
      scaffoldBackgroundColor:
          isDarkTheme ? AppColor.DarkScaffold : AppColor.LightScaffold,
      cardColor: isDarkTheme
          ? const Color.fromARGB(255, 13, 6, 37)
          : AppColor.LightCardColor,
    );
  }
}
