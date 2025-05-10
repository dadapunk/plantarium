import 'package:json_annotation/json_annotation.dart';
import 'package:plantarium/core/models/plant/plant.dto.dart';

part 'plot.dto.g.dart';

@JsonSerializable()
class PlotDTO {
  PlotDTO({
    required this.name,
    required this.width,
    required this.length,
    required this.plants,
    this.id,
    this.description,
    this.imageUrl,
  });

  factory PlotDTO.fromJson(final Map<String, dynamic> json) =>
      _$PlotDTOFromJson(json);
  final int? id;
  final String name;
  final String? description;
  final double width;
  final double length;
  final String? imageUrl;
  final List<PlantDTO> plants;
  Map<String, dynamic> toJson() => _$PlotDTOToJson(this);
}
