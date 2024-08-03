import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/DB/database.dart';
import 'package:notes/controller/them_controller.dart';
import 'package:notes/controller/view/favorite.dart';
import 'package:notes/controller/view/search.dart';
import 'package:notes/custom_widget/wigets.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: const Text(
            'Notes',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Get.snackbar(
              'Hi',
              'Bro ${themeController.isDark.value ? '🌚' : "🌞"}',
              duration: const Duration(milliseconds: 600),
            );
          },
          onDoubleTap: () => Get.snackbar('🗣️<Fuck you', ''),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              Get.to(NoteSearchDelegate());
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            tooltip: 'Favorite notes',
            onPressed: () {
              Get.off(const MyFavorite());
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete all notes',
            onPressed: () async {
              await NotesDatabase.instance.deleteAllNotes();
              Get.snackbar('Success',
                  'Delete all notes ${themeController.isDark.value ? '🌚' : "🌞"}');
            },
          ),
          Obx(() {
            return IconButton(
              icon: Icon(
                themeController.isDark.value
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              onPressed: () {
                themeController.changeTheme();
                Get.snackbar('Success',
                    'Change theme ${themeController.isDark.value ? '🌚' : "🌞"}');
              },
            );
          }),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding:
              MediaQuery.of(context).viewInsets + const EdgeInsets.all(5.0),
          child: GetNotes(
            notes: NotesDatabase.instance.readAllNotes(),
          ),
        ),
      ),
      floatingActionButton:
          CustomFloatActionButton(themeController: themeController),
    );
  }
}
