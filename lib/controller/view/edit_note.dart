import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/DB/database.dart';
import 'package:notes/custom_widget/wigets.dart';
import 'package:notes/models/note_model.dart';

import '../NotesController.dart';

class EditNote extends StatelessWidget {
  EditNote({super.key, required this.note}) {
    titleController.text = note.title;
    contentController.text = note.content;
    _isFavorite = note.isFavorite;
  }

  final NoteModel note;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final NotesController notesController =
        Get.put(NotesController()); // الحصول على وحدة التحكم

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        _isFavorite = !_isFavorite;
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    labelText: 'Title',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: contentController,
                  maxLines: 20,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    labelText: 'Content',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty ||
                        contentController.text.isEmpty) {
                      Get.snackbar(
                          'Error', 'Title and content cannot be empty 🚫');
                      return;
                    }

                    final updatedNote = note.copy(
                      title: titleController.text,
                      content: contentController.text,
                      isFavorite: _isFavorite,
                      createdTime: formatDateTimeCustom(DateTime.now()),
                    );

                    // استخدام وحدة التحكم لتحديث الملاحظة
                    notesController.updateNote(updatedNote);

                    Get.snackbar('Success❤️', 'Note updated successfully 📝');

                    Navigator.pop(context);
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
