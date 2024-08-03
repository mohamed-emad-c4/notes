import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/controller/them_controller.dart';
import 'package:notes/controller/view/Home.dart';
import 'controller/view/favorite.dart';

void main() {
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(() {
      return GetMaterialApp(
        getPages: [
          GetPage(name: '/', page: () => const Home()),
          GetPage(name: '/favorite', page: () => const MyFavorite()),
        ],
        title: 'Notes',
        debugShowCheckedModeBanner: false,
        theme: themeController.theme,
        home: const Home(),
      );
    });
  }
}
