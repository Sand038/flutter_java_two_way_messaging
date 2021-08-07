import 'package:json_annotation/json_annotation.dart';

import './message.dart';

part 'messages_with_count.g.dart';

@JsonSerializable(explicitToJson: true)
class MessagesWithCount {
  final int count;
  final List<Message> messages;

  MessagesWithCount(this.count, this.messages);

  factory MessagesWithCount.fromJson(Map<String, dynamic> json) =>
      _$MessagesWithCountFromJson(json);

  Map<String, dynamic> toJson() => _$MessagesWithCountToJson(this);
}
