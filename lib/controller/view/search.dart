import 'package:flutter/material.dart';
import 'package:notes/DB/database.dart';
import 'package:notes/models/note_model.dart';

class NoteSearchDelegate extends StatefulWidget {
  final Function(List<NoteModel>) onNotesFiltered;

  const NoteSearchDelegate({Key? key, required this.onNotesFiltered})
      : super(key: key);

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
      return titleLower.contains(queryLower) || contentLower.contains(queryLower);
    }).toList();

    setState(() {
      _filteredNotes = filteredNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Search Notes'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
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
                  trailing: Icon(
                    note.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: note.isFavorite ? Colors.red : Colors.grey,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onNotesFiltered(_filteredNotes);
                  },
                );
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
