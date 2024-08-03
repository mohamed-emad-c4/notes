import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/controller/them_controller.dart';
import 'package:notes/controller/view/Home.dart';

void main() {
  Get.put(ThemeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // الحصول على المثيل الواحد من ThemeController
    final ThemeController themeController = Get.find();

    return Obx(() {
      return GetMaterialApp(
        
        title: 'Notes',
        debugShowCheckedModeBanner: false,
        theme: themeController.theme,
        home: const Home(),
      );
    });
  }
}
