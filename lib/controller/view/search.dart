import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/DB/database.dart';
import 'package:notes/models/note_model.dart';
import '../../custom_widget/wigets.dart'; // Adjusted import name

class NoteSearchDelegate extends StatefulWidget {
  const NoteSearchDelegate({Key? key}) : super(key: key);

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
    try {
      final notes = await NotesDatabase.instance.readAllNotes();
      setState(() {
        _notes = notes;
        _filteredNotes = notes;
      });
    } catch (e) {
      print('Error loading notes: $e');
    }
  }

  void _filterNotes(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredNotes = _notes.where((note) {
        final titleLower = note.title.toLowerCase();
        final contentLower = note.content.toLowerCase();
        return titleLower.contains(lowerQuery) ||
            contentLower.contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Notes'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              _filterNotes('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    hintText: 'Search notes...',
                    contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  onChanged: _filterNotes,
                ),
              ),
              const SizedBox(height: 16),
              // Notes List
              Expanded(
                child: _filteredNotes.isEmpty
                    ? const Center(
                        child: Text('No notes found',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.w500)))
                    : ListView.builder(
                        itemCount: _filteredNotes.length,
                        itemBuilder: (context, index) {
                          final note = _filteredNotes[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16.0),
                              title: Text(note.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              subtitle: Text(note.content,
                                  maxLines: 3, overflow: TextOverflow.ellipsis),
                              trailing: CustomIconButtonChange(note: note),
                              onTap: () {
                                // Handle note tap if needed
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
