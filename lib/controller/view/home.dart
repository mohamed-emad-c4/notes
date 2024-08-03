import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/DB/database.dart';
import 'package:notes/controller/them_controller.dart';
import 'package:notes/controller/view/search.dart';
import 'package:notes/custom_widget/wigets.dart';
import 'package:notes/models/note_model.dart';
import 'package:sqflite/sqflite.dart';

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
                'Hi', 'Bro ${themeController.isDark.value ? '🌚' : "🌞"} ',
                duration: const Duration(milliseconds: 600));
          },
          onDoubleTap: () => Get.snackbar('🗣️<Fuck you', ''),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () async {
              // final results =
              //     await NotesDatabase.instance.searchDatabase('mohamed');
              // print(results);

              // for (var row in results) {
              //   print(row.title);
              // }
              // List<NoteModel> notes =
              //     await NotesDatabase.instance.readAllNotes().then((value) {
              //   for (var element in value) {
              //     //  print("id:::::" + " ${element.id}");
              //   }
              //   return value;
              // });
              Get.to(NoteSearchDelegate());
              Get.snackbar('🗣️<Fuck you', 'Bro ');
              Get.forceAppUpdate();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete all notes',
            onPressed: () async {
              await NotesDatabase.instance.deleteAllNotes();
              Get.forceAppUpdate();
              Get.snackbar('Success',
                  'Delete all notes ${themeController.isDark.value ? '🌚' : "🌞"} ');
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
              onPressed: () {
                themeController.changeTheme();
                Get.snackbar('Success',
                    'change theme ${themeController.isDark.value ? '🌚' : "🌞"} ');
              },
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
      floatingActionButton:
          CustomFloadActionBottom(themeController: themeController),
    );
  }
}
