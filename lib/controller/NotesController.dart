import 'package:get/get.dart';
import 'package:notes/DB/database.dart';
import 'package:notes/models/note_model.dart';

class NotesController extends GetxController {
  var notes = <NoteModel>[].obs; // ملاحظات باستخدام Rx

  @override
  void onInit() {
    super.onInit();
    fetchNotes(); // تحميل الملاحظات عند بدء التحكم
  }

  // استرجاع جميع الملاحظات
  void fetchNotes() async {
    final data = await NotesDatabase.instance.readAllNotes();
    notes.value = data; // تحديث قائمة الملاحظات
  }

  // تحديث ملاحظة
  void updateNote(NoteModel note) async {
    await NotesDatabase.instance.update(note);
    fetchNotes(); // إعادة تحميل الملاحظات بعد التحديث
  }
}
