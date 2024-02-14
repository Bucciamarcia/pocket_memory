// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dbmodels.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Memory _$MemoryFromJson(Map<String, dynamic> json) => Memory(
      content: json['content'] as String? ?? "",
      date: DateTime.parse(json['date'] as String),
      isTemporary: json['isTemporary'] as bool? ?? false,
      expiration: json['expiration'] == null
          ? null
          : DateTime.parse(json['expiration'] as String),
      embeddings: (json['embeddings'] as List<dynamic>?)
              ?.map((e) => e as num)
              .toList() ??
          const [0],
    );

Map<String, dynamic> _$MemoryToJson(Memory instance) => <String, dynamic>{
      'content': instance.content,
      'date': instance.date.toIso8601String(),
      'isTemporary': instance.isTemporary,
      'expiration': instance.expiration?.toIso8601String(),
      'embeddings': instance.embeddings,
    };
