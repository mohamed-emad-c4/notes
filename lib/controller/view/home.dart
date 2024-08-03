import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/DB/database.dart';
import 'package:notes/controller/them_controller.dart';
import 'package:notes/custom_widget/wigets.dart';
import 'package:notes/models/note_model.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Notes', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              // Implement search functionality here
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete all notes',
            onPressed: () async {
              await NotesDatabase.instance.deleteAllNotes();
              Get.forceAppUpdate();
              // Implement search functionality here
            },
          ),
          Obx(() {
            return IconButton(
              icon: Icon(
                themeController.isDark.value
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              onPressed: themeController.changeTheme,
            );
          }),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding:
              MediaQuery.of(context).viewInsets + const EdgeInsets.all(5.0),
          child: GetNotes(),
        ),
      ),
      floatingActionButton: CustomFloadActionBottom(themeController: themeController),
    );
  }
}
