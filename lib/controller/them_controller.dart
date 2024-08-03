import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var isDark = false.obs;

  ThemeData get theme => isDark.value
      ? ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(),
        )
      : ThemeData(
          brightness: Brightness.light,
        );

  void changeTheme() {
    isDark.value = !isDark.value;
  }
}
