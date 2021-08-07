// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_with_count.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessagesWithCount _$MessagesWithCountFromJson(Map<String, dynamic> json) =>
    MessagesWithCount(
      json['count'] as int,
      (json['messages'] as List<dynamic>)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MessagesWithCountToJson(MessagesWithCount instance) =>
    <String, dynamic>{
      'count': instance.count,
      'messages': instance.messages.map((e) => e.toJson()).toList(),
    };
