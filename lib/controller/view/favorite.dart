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
      appBar: AppBar(
        title: const Text('Favorite Notes'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              const Text(
                'Favorite❤️',
                style: TextStyle(fontSize: 30),
              ),
              Expanded(
                child: GetNotes(
                  notes: NotesDatabase.instance.getAllFavoriteNotes(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.off(const Home());
                },
                child: const Text(
                  'Notes',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
