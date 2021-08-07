// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './messages/models/message.dart';
import './messages/models/messages_with_count.dart';
import './messages/service/random_message_service.dart';

class FlutterJavaTwoWayMessaging extends StatefulWidget {
  const FlutterJavaTwoWayMessaging({Key? key}) : super(key: key);

  @override
  State<FlutterJavaTwoWayMessaging> createState() => _FlutterJavaTwoWayMessagingState();
}

class _FlutterJavaTwoWayMessagingState extends State<FlutterJavaTwoWayMessaging> {
  Message _inputMessage = new Message('', 0);
  String _resultMessage = 'No messages received yet!';
  int _count = 0;
  List<String> _messages = [];
  late RandomMessageService _randomMessageService;
  String _pollingResult = 'No results received yet';

  Future<void> _getMessage() async {
    try {
      _inputMessage = _randomMessageService.getInputMessage(_count++);
      MessagesWithCount messageWithCount =
          await _randomMessageService.getRandomMessage(_inputMessage);
      setState(() {
        _resultMessage =
            '${messageWithCount.messages[0].text} => ${messageWithCount.count}';
        _messages.add(_resultMessage);
      });
      print(_resultMessage);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void processUpdates(Message message) {
    setState(() {
      _pollingResult = message.text + message.value.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _randomMessageService = new RandomMessageService(processUpdates);
    _randomMessageService.startTestPolling();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
                'Input message : ${_inputMessage.text} => ${_inputMessage.value}'),
            ElevatedButton(
              child: Text('Get updated message'),
              onPressed: _getMessage,
            ),
            Text('Result message : $_resultMessage'),
            Text(_pollingResult),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: FlutterJavaTwoWayMessaging()));
}
