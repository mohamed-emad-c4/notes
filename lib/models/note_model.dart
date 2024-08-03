import 'package:notes/DB/database.dart';

class NoteModel {
  final int? id;
  final int number; // إضافة حقل number
  final String title;
  final String content;
  final bool isFavorite;
  final String createdTime;

  NoteModel({
    this.id,
    this.number = 0, // تعيين قيمة افتراضية لـ number
    required this.title,
    required this.content,
    this.isFavorite = false,
    required this.createdTime,
  });

  Map<String, dynamic> toJson() => {
        NoteFields.id: id,
        NoteFields.number: number, // تأكد من تضمين number في الخريطة
        NoteFields.title: title,
        NoteFields.content: content,
        NoteFields.isFavorite: isFavorite ? 1 : 0,
        NoteFields.createdTime: createdTime,
      };

  static NoteModel fromJson(Map<String, dynamic> json) => NoteModel(
        id: json[NoteFields.id] as int?,
        number: json[NoteFields.number] as int, // تضمين number في التحليل
        title: json[NoteFields.title] as String,
        content: json[NoteFields.content] as String,
        isFavorite: json[NoteFields.isFavorite] == 1,
        createdTime:(json[NoteFields.createdTime] as String),
      );

  NoteModel copy({
    int? id,
    int? number,
    String? title,
    String? content,
    bool? isFavorite,
    String? createdTime,
  }) =>
      NoteModel(
        id: id ?? this.id,
        number: number ?? this.number, // التأكد من تضمين number
        title: title ?? this.title,
        content: content ?? this.content,
        isFavorite: isFavorite ?? this.isFavorite,
        createdTime: createdTime ?? this.createdTime,
      );
}

class NoteFields {
  static const String tableName = 'notes';
  static const String id = '_id';
  static const String number = 'number'; // إضافة الحقل number
  static const String title = 'title';
  static const String content = 'content';
  static const String isFavorite = 'is_favorite';
  static const String createdTime = 'created_time';

  static final List<String> values = [
    id,
    number, // إضافة الحقل number إلى القائمة
    title,
    content,
    isFavorite,
    createdTime,
  ];
}
