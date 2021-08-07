import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/message.dart';
import '../models/messages.dart';
import '../models/messages_with_count.dart';

class RandomMessageService {
  static const randomMessageChannel =
      MethodChannel('samples.flutter.dev/messages');
  Function processUpdates;

  RandomMessageService(this.processUpdates) {
    randomMessageChannel.setMethodCallHandler(randomMessageHandler);
  }

  Future<MessagesWithCount> getRandomMessage(Message _inputMessage) async {
    var inputMessages = jsonEncode(Messages([_inputMessage]));
    String response = await randomMessageChannel
        .invokeMethod('getMessage', {"messages": inputMessages});
    MessagesWithCount messageWithCount =
        MessagesWithCount.fromJson(jsonDecode(response));
    messageWithCount = messageWithCount;
    return messageWithCount;
  }

  Message getInputMessage(int _count) =>
      Message("message " + _count.toString(), _count);

  Future<void> startTestPolling() async {
    print('starting test polling');
    await randomMessageChannel.invokeMethod('testPolling');
  }

  Future<dynamic> randomMessageHandler(MethodCall methodCall) async {
    if (methodCall.method == 'getUpdates') {
      processUpdates(Message.fromJson(jsonDecode(methodCall.arguments)));
    } else {
      throw MissingPluginException('notImplemented');
    }
  }
}
