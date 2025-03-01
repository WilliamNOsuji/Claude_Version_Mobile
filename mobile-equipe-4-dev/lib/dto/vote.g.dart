// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuggestedProductDTO _$SuggestedProductDTOFromJson(Map<String, dynamic> json) =>
    SuggestedProductDTO(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      photo: json['photo'] as String?,
      finishDate: DateTime.parse(json['finishDate'] as String),
      userVote: json['userVote'] as String?,
    );

Map<String, dynamic> _$SuggestedProductDTOToJson(
        SuggestedProductDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photo': instance.photo,
      'finishDate': instance.finishDate.toIso8601String(),
      'userVote': instance.userVote,
    };
