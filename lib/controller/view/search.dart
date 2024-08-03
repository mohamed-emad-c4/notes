import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:notes/DB/database.dart';
import 'package:notes/custom_widget/wigets.dart';
import 'package:notes/models/note_model.dart';

class NoteSearchDelegate extends StatefulWidget {
  const NoteSearchDelegate({
    Key? key,
  }) : super(key: key);

  @override
  _NoteSearchDelegateState createState() => _NoteSearchDelegateState();
}

class _NoteSearchDelegateState extends State<NoteSearchDelegate> {
  final TextEditingController _searchController = TextEditingController();
  List<NoteModel> _notes = [];
  List<NoteModel> _filteredNotes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await NotesDatabase.instance.readAllNotes();
    setState(() {
      _notes = notes;
      _filteredNotes = notes;
    });
  }

  void _filterNotes(String query) {
    final filteredNotes = _notes.where((note) {
      final titleLower = note.title.toLowerCase();
      final contentLower = note.content.toLowerCase();
      final queryLower = query.toLowerCase();
      return titleLower.contains(queryLower) ||
          contentLower.contains(queryLower);
    }).toList();

    setState(() {
      _filteredNotes = filteredNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  hintText: 'Enter search query',
                ),
                onChanged: (query) {
                  _filterNotes(query);
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredNotes.length,
                  itemBuilder: (context, index) {
                    final note = _filteredNotes[index];
                    return ListTile(
                      title: Text(note.title),
                      subtitle: Text(note.content),
                      trailing: CustomIconBottonChange(note: note),
                    );
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    'Back',
                    style: TextStyle(fontSize: 20),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              )
            ],
          ),
        ),
      ),
    );
  }
}
