import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/DB/database.dart';
import 'package:notes/controller/view/Home.dart';

import '../../custom_widget/wigets.dart';

class MyFavorite extends StatelessWidget {
  const MyFavorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: MediaQuery.of(context).viewInsets + const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('Favorite❤️', style: TextStyle(fontSize: 30)),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.79,
              child: GetNotes(
                notes: NotesDatabase.instance.getAllFavoriteNotes(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.off(Home());
              },
              child: Text(
                'Notes',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
