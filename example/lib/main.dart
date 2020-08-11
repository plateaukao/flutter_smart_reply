import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_smart_reply/flutter_smart_reply.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<TextMessage> _textMessages = [
    TextMessage.createForRemoteUser("I'm hungry.", DateTime.now().millisecondsSinceEpoch),
  ];

  List<String> _replies = List.empty();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _replies = await FlutterSmartReply.getSmartReplies(_textMessages);

      debugPrint(_replies.toString());
    } on PlatformException {
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Smart Reply Example'),
        ),
        body: Center(
          child: Text('replies: ${_replies.toString()}\n'),
        ),
      ),
    );
  }
}
