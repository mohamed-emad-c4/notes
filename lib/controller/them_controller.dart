import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var isDark = false.obs;

  ThemeData get theme => isDark.value
      ? ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(),
        )
      : ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.light(),
        );
  // ThemeData get theme => isDark.value ? ThemeData.dark() : ThemeData.light(

  void changeTheme() {
    isDark.value = !isDark.value;
  }
}
