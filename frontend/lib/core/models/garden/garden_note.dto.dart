import 'package:json_annotation/json_annotation.dart';

part 'garden_note.dto.g.dart';

@JsonSerializable()
class GardenNoteDTO {
  final int? id;
  final String title;
  final String note;
  final DateTime date;

  GardenNoteDTO({
    this.id,
    required this.title,
    required this.note,
    required this.date,
  });

  factory GardenNoteDTO.fromJson(Map<String, dynamic> json) =>
      _$GardenNoteDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GardenNoteDTOToJson(this);

  // Helper method to create a new note
  static GardenNoteDTO create({required String title, required String note}) {
    // Using DateTime.now() and ensuring it has no time component to match backend's date type
    final now = DateTime.now();
    final dateOnly = DateTime(now.year, now.month, now.day);

    return GardenNoteDTO(title: title, note: note, date: dateOnly);
  }

  // Helper method to update an existing note
  GardenNoteDTO copyWith({String? title, String? note, DateTime? date}) {
    return GardenNoteDTO(
      id: id,
      title: title ?? this.title,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }
}
