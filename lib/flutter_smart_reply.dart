
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterSmartReply {
  static const MethodChannel _channel = const MethodChannel('flutter_smart_reply');

  static Future<String> get platformVersion async => await _channel.invokeMethod('getPlatformVersion');

  static Future<List<String>> getSmartReplies(List<TextMessage> messageList) async =>
      await _channel.invokeMethod('getSmartReplies');
}

class TextMessage {
  String text;
  int timestamp;
  String uerId;

  TextMessage.createForLocalUser(this.text, this.timestamp) : this.uerId = '';

  TextMessage.createForRemoteUser(this.text, this.timestamp, this.uerId);
}
