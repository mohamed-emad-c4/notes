import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/DB/database.dart';
import 'package:notes/controller/them_controller.dart';
import 'package:notes/controller/view/edit_note.dart';
import '../models/note_model.dart';

class GetNotes extends StatelessWidget {
  GetNotes({
    super.key,
    required this.notes,
  });

  final Future<List<NoteModel>> notes;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NoteModel>>(
      future: notes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No notes available'));
        } else {
          final notes = snapshot.data!.reversed.toList();

          return CustomBuildNote(notes: notes);
        }
      },
    );
  }
}

class CustomBuildNote extends StatelessWidget {
  const CustomBuildNote({
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
                        width: MediaQuery.of(context).size.width * 0.67,
                        child: Text(
                          note.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              NotesDatabase.instance
                                  .delete(note.id!)
                                  .then((value) => Get.forceAppUpdate());
                            },
                            icon: const Icon(Icons.delete),
                          ),
                          CustomIconButtonChange(note: note),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.content,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 5,
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
                        onPressed: () async {
                          try {
                            NoteModel noteEdit = await NotesDatabase.instance
                                .readNote(note.id!);
                            Get.to(() => EditNote(note: noteEdit));
                          } catch (error) {
                            print('Error retrieving note: $error');
                          }
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

class CustomIconButtonChange extends StatelessWidget {
  const CustomIconButtonChange({
    super.key,
    required this.note,
  });

  final NoteModel note;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        note.isFavorite ? Icons.favorite : Icons.favorite_border,
        color: note.isFavorite ? Colors.red : Colors.grey,
        size: 30,
      ),
      onPressed: () {
        NotesDatabase.instance.update(note.copy(isFavorite: !note.isFavorite));
        Get.forceAppUpdate();
        Get.snackbar(
          'Success',
          note.isFavorite ? 'Note removed from Favorites 💩' : 'Note added to Favorites ❤️',
        );
      },
    );
  }
}

class CustomFloatActionButton extends StatelessWidget {
  const CustomFloatActionButton({
    super.key,
    required this.themeController,
  });

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Get.bottomSheet(
          HandleBottomSheet(themeController: themeController),
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
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: color,
      ),
    );
  }
}

class InputField extends StatelessWidget {
  InputField({
    this.maxLines = 1,
    this.text = 'Add Note',
    super.key,
  });

  final String text;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: text,
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

class HandleBottomSheet extends StatefulWidget {
  final ThemeController themeController;

  const HandleBottomSheet({super.key, required this.themeController});

  @override
  _HandleBottomSheetState createState() => _HandleBottomSheetState();
}

class _HandleBottomSheetState extends State<HandleBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isFavorite = false;

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
                isFavorite: _isFavorite,
                createdTime: formatDateTimeCustom(DateTime.now()),
              );

              await NotesDatabase.instance.create(note);
              Get.back();
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

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
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
