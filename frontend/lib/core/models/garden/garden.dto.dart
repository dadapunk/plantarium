import 'package:json_annotation/json_annotation.dart';
import '../plot/plot.dto.dart';
import '../user/user.dto.dart';

part 'garden.dto.g.dart';

@JsonSerializable()
class GardenDTO {
  final int? id;
  final String name;
  final String? description;
  final String? location;
  final String? imageUrl;
  final List<PlotDTO> plots;
  final UserDTO owner;

  GardenDTO({
    this.id,
    required this.name,
    this.description,
    this.location,
    this.imageUrl,
    required this.plots,
    required this.owner,
  });

  factory GardenDTO.fromJson(Map<String, dynamic> json) =>
      _$GardenDTOFromJson(json);
  Map<String, dynamic> toJson() => _$GardenDTOToJson(this);
}
