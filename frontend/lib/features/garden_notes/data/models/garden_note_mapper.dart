import 'package:plantarium/features/garden_notes/data/models/garden_note.dto.dart';
import 'package:plantarium/features/garden_notes/domain/entities/garden_note.entity.dart';

/// Mapper class to convert between GardenNoteDTO and GardenNote entity
class GardenNoteMapper {
  /// Converts a GardenNoteDTO to a GardenNote entity
  static GardenNote toEntity(GardenNoteDTO dto) {
    return GardenNote(
      id: dto.id,
      title: dto.title,
      content: dto.note,
      date: dto.date,
    );
  }

  /// Converts a GardenNote entity to a GardenNoteDTO
  static GardenNoteDTO fromEntity(GardenNote entity) {
    return GardenNoteDTO(
      id: entity.id,
      title: entity.title,
      note: entity.content,
      date: entity.date,
    );
  }

  /// Converts a list of GardenNoteDTO to a list of GardenNote entities
  static List<GardenNote> toEntityList(List<GardenNoteDTO> dtoList) {
    return dtoList.map((dto) => toEntity(dto)).toList();
  }

  /// Converts a list of GardenNote entities to a list of GardenNoteDTO
  static List<GardenNoteDTO> fromEntityList(List<GardenNote> entityList) {
    return entityList.map((entity) => fromEntity(entity)).toList();
  }
}
