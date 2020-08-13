import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class FlutterSmartReply {
  static const MethodChannel _channel = const MethodChannel('flutter_smart_reply');

  static Future<List<String>> getSmartReplies(List<TextMessage> messageList) async {
    final jsonString = await _channel.invokeMethod('getSmartReplies', jsonEncode(messageList));
    return List<String>.from(jsonDecode(jsonString));
  }
}

class TextMessage {
  String text;
  int timestamp;
  bool isSelf;


  TextMessage(this.text, this.timestamp, this.isSelf);

  Map<String, dynamic> toJson() =>
      {
        'text': text,
        'timestamp': timestamp,
        'isSelf' : false,
      };

  TextMessage.createForLocalUser(this.text, this.timestamp) : this.isSelf= true;

  TextMessage.createForRemoteUser(this.text, this.timestamp) : this.isSelf = false;
}