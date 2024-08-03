import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/DB/database.dart';
import 'package:notes/controller/them_controller.dart';

import '../models/note_model.dart';

// class Note extends StatelessWidget {
//   const Note({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: MediaQuery.of(context).size.height * 0.29,
//       child: Card(
//         elevation: 100,
//         shadowColor: Colors.amber,
//         color: Colors.amber,
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const Text(
//                       'Note Title',
//                       maxLines: 1,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         overflow: TextOverflow.ellipsis,
//                         fontSize: 18,
//                       ),
//                     ),
//                     const Spacer(),
//                     CustomIconBottom(
//                         onpressed1: () {}, icon: Icons.favorite_outline),
//                     CustomIconBottom(onpressed1: () {}, icon: Icons.edit),
//                     CustomIconBottom(onpressed1: () {}, icon: Icons.delete),
//                   ],
//                 ),
//                 const Text(
//                   '''Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.''',
//                   maxLines: 7,
//                   style: TextStyle(
//                     color: Color.fromARGB(255, 69, 69, 69),
//                     fontWeight: FontWeight.bold,
//                     overflow: TextOverflow.ellipsis,
//                     fontSize: 12,
//                   ),
//                 ),
//                 const Row(
//                   children: [
//                     Spacer(),
//                     Text(
//                       '15/4/2024 10:00 AM',
//                       maxLines: 1,
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontWeight: FontWeight.bold,
//                         overflow: TextOverflow.ellipsis,
//                         fontSize: 12,
//                       ),
//                     ),
//                     SizedBox(width: 5),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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
                Get.snackbar('Error', 'Title and content cannot be empty');
                return ;
              }

              final note = NoteModel(
                number: 1,
                title: _titleController.text,
                content: _contentController.text,
                isFavorite: _isFavorite, // استخدام حالة المفضلة هنا
                createdTime: DateTime.now(),
              );

              await NotesDatabase.instance.create(note);
              Get.back(); // إغلاق الـ Bottom Sheet بعد حفظ الملاحظة
              Get.snackbar('Success', 'Note added successfully');
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
