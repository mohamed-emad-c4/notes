import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/DB/database.dart';
import 'package:notes/controller/them_controller.dart';

import '../models/note_model.dart';

class GetNotes extends StatelessWidget {
  const GetNotes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NoteModel>>(
      future: NotesDatabase.instance.readAllNotes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No notes available'));
        } else {
          final notes = snapshot.data!.reversed.toList();

          return CoustomBuildNote(notes: notes);
        }
      },
    );
  }
}

class CoustomBuildNote extends StatelessWidget {
  const CoustomBuildNote({
    super.key,
    required this.notes,
  });

  final List<NoteModel> notes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10),
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              // Navigate to detail page or edit note
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          note.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              log(index.toString());
                              NotesDatabase.instance
                                  .delete(note.id!)
                                  .then((value) => Get.forceAppUpdate());
                            },
                            icon: Icon(Icons.delete),
                          ),
                          IconButton(
                            icon: Icon(
                              note.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: note.isFavorite ? Colors.red : Colors.grey,
                              size: 30,
                            ),
                            onPressed: () {
                              NotesDatabase.instance.update(
                                  note.copy(isFavorite: !note.isFavorite));
                              Get.forceAppUpdate();
                              if (note.isFavorite) {
                                Get.snackbar(
                                  'Success',
                                  'Note removed Favorite 💩',
                                );
                              } else {
                                Get.snackbar(
                                  'Success',
                                  'Note added Favorite ❤️',
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.content,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Created: ${note.createdTime}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Edit note
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomFloadActionBottom extends StatelessWidget {
  const CustomFloadActionBottom({
    super.key,
    required this.themeController,
  });

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Get.bottomSheet(
          HandelBottomSheet(themeController: themeController),
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        );
      },
      icon: const Icon(Icons.add),
      label: const Text('Add Note'),
    );
  }
}

class CustomIconBottom extends StatelessWidget {
  CustomIconBottom({
    this.icon = Icons.favorite,
    this.color = Colors.black,
    required this.onpressed1,
    super.key,
  });
  IconData icon;
  Color color;
  Function onpressed1;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onpressed1(),
        icon: Icon(
          icon,
          color: color,
        ));
  }
}

class InputFiled extends StatelessWidget {
  InputFiled({
    this.maxLines = 1,
    this.text1 = 'Add Note',
    super.key,
  });
  String text1;
  int maxLines;
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: text1,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: Colors.grey, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: Colors.grey, width: 2),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}

class HandelBottomSheet extends StatefulWidget {
  final ThemeController themeController;

  const HandelBottomSheet({super.key, required this.themeController});

  @override
  _HandelBottomSheetState createState() => _HandelBottomSheetState();
}

class _HandelBottomSheetState extends State<HandelBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isFavorite = false; // حالة المفضلة الافتراضية

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.themeController.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(labelText: 'Content'),
            maxLines: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Favorite'),
              Switch(
                value: _isFavorite,
                onChanged: (value) {
                  setState(() {
                    _isFavorite = value;
                  });
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              if (_titleController.text.isEmpty ||
                  _contentController.text.isEmpty) {
                Get.snackbar('Error', 'Title and content cannot be empty 🚫');
                return;
              }

              final note = NoteModel(
                number: 1,
                title: _titleController.text,
                content: _contentController.text,
                isFavorite: _isFavorite, // استخدام حالة المفضلة هنا
                createdTime: formatDateTimeCustom(DateTime.now()),
              );

              await NotesDatabase.instance.create(note);
              Get.back(); // إغلاق الـ Bottom Sheet بعد حفظ الملاحظة
              Get.snackbar('Success❤️', 'Note added successfully 📝');
              NotesDatabase.instance.close();
            },
            child: const Text('Add Note'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}

class CoutomAppBar extends StatelessWidget {
  const CoutomAppBar({
    super.key,
    required this.themeController,
  });

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        children: [
          Text('Notes', style: Theme.of(context).textTheme.headlineLarge),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          Obx(
            () {
              return IconButton(
                onPressed: () {
                  themeController.changeTheme();
                },
                icon: Icon(
                  themeController.isDark.value
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

String formatDateTimeCustom(DateTime dateTime) {
  int year = dateTime.year;
  int month = dateTime.month;
  int day = dateTime.day;
  int hour = dateTime.hour;
  int minute = dateTime.minute;
  int second = dateTime.second;
  String period = hour >= 12 ? 'PM' : 'AM';
  hour = hour % 12;
  hour = hour == 0 ? 12 : hour;
  return '$year/$month/$day $hour:$minute:$second $period';
}
