// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:notes/DB/database.dart';
// import 'package:notes/models/note_model.dart';
// import 'package:notes/controller/them_controller.dart';

// // class HandelBottomSheet extends StatefulWidget {
// //   final ThemeController themeController;

// //   const HandelBottomSheet({super.key, required this.themeController});

// //   @override
// //   _HandelBottomSheetState createState() => _HandelBottomSheetState();
// // }

// // class _HandelBottomSheetState extends State<HandelBottomSheet> {
// //   final TextEditingController _titleController = TextEditingController();
// //   final TextEditingController _contentController = TextEditingController();
// //   bool _isFavorite = false; // حالة المفضلة الافتراضية

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: widget.themeController.theme.scaffoldBackgroundColor,
// //         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
// //       ),
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           TextField(
// //             controller: _titleController,
// //             decoration: const InputDecoration(labelText: 'Title'),
// //           ),
// //           TextField(
// //             controller: _contentController,
// //             decoration: const InputDecoration(labelText: 'Content'),
// //             maxLines: 3,
// //           ),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               const Text('Favorite'),
// //               Switch(
// //                 value: _isFavorite,
// //                 onChanged: (value) {
// //                   setState(() {
// //                     _isFavorite = value;
// //                   });
// //                 },
// //               ),
// //             ],
// //           ),
// //           ElevatedButton(
// //             onPressed: () async {
// //               if (_titleController.text.isEmpty ||
// //                   _contentController.text.isEmpty) {
// //                 Get.snackbar('Error', 'Title and content cannot be empty');
// //                 return;
// //               }

// //               final note = NoteModel(
// //                 number: 1,
// //                 title: _titleController.text,
// //                 content: _contentController.text,
// //                 isFavorite: _isFavorite, // استخدام حالة المفضلة هنا
// //                 createdTime: DateTime.now(),
// //               );

// //               await NotesDatabase.instance.create(note);
// //               Get.back(); // إغلاق الـ Bottom Sheet بعد حفظ الملاحظة
// //               Get.snackbar('Success', 'Note added successfully');
// //             },
// //             child: const Text('Add Note'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _titleController.dispose();
// //     _contentController.dispose();
// //     super.dispose();
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:notes/DB/database.dart';
// import 'package:notes/controller/them_controller.dart';
// import 'package:notes/custom_widget/wigets.dart';
// import 'package:notes/models/note_model.dart';

// class Home extends StatelessWidget {
//   const Home({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final ThemeController themeController = Get.find();

//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(1.0),
//           child: Column(
//             children: [
//               CoutomAppBar(themeController: themeController),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.87,
//                 child: FutureBuilder<List<NoteModel>>(
//                   future: NotesDatabase.instance.readAllNotes(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return const Center(child: Text('No notes available'));
//                     } else {
//                       final notes = snapshot.data!;

//                       return ListView.builder(
//                         scrollDirection: Axis.vertical,
//                         itemCount: notes.length,
//                         itemBuilder: (context, index) {
//                           final note = notes[index];
//                           return ListTile(
//                             title: Text(note.title),
//                             subtitle: Text(note.content),
//                             trailing: Icon(
//                               note.isFavorite
//                                   ? Icons.favorite
//                                   : Icons.favorite_border,
//                               color:
//                                   note.isFavorite ? Colors.red : Colors.grey,
//                             ),
//                           );
//                         },
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
         
//           Get.bottomSheet(
//             HandelBottomSheet(themeController: themeController),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
