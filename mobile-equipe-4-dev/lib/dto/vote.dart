
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
///
/// Command: flutter pub run build_runner build
part 'vote.g.dart';

@JsonSerializable()
class SuggestedProductDTO {
  final int id;
  final String name;
  final String? photo;
  final DateTime finishDate;
  // Remove final so this field becomes mutable:
  String? userVote;

  SuggestedProductDTO({
    required this.id,
    required this.name,
    this.photo,
    required this.finishDate,
    this.userVote,
  });

  factory SuggestedProductDTO.fromJson(Map<String, dynamic> json) =>
      _$SuggestedProductDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SuggestedProductDTOToJson(this);
}


