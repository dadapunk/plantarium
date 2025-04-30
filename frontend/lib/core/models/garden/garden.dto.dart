import 'package:json_annotation/json_annotation.dart';
import 'package:plantarium/core/models/plot/plot.dto.dart';
import 'package:plantarium/core/models/user/user.dto.dart';

part 'garden.dto.g.dart';

@JsonSerializable()
class GardenDTO {
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
  final int? id;
  final String name;
  final String? description;
  final String? location;
  final String? imageUrl;
  final List<PlotDTO> plots;
  final UserDTO owner;
  Map<String, dynamic> toJson() => _$GardenDTOToJson(this);
}
