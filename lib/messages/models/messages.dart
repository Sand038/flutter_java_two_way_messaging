import 'package:json_annotation/json_annotation.dart';

import './message.dart';

part 'messages.g.dart';

@JsonSerializable(explicitToJson: true)
class Messages {
  final List<Message> messages;

  Messages(this.messages);

  factory Messages.fromJson(Map<String, dynamic> json) =>
      _$MessagesFromJson(json);

  Map<String, dynamic> toJson() => _$MessagesToJson(this);
}
