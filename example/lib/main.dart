import 'dart:async';

import 'package:flutter/material.dart';
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

  final myController = TextEditingController();

  List<String> _replies = List.empty();

  bool isSelfMode = true;

  Future<void> updateSmartReplies() async {
    try {
      _replies = await FlutterSmartReply.getSmartReplies(_textMessages);
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Smart Reply Example')),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                  child: ListView(
                shrinkWrap: true,
                reverse: true,
                children: _textMessages.reversed.map(_buildMessageItem).toList(),
              )),
              _buildSmartReplyRow(),
              _buildInputField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageItem(TextMessage message) => Container(
        height: 70,
        alignment: message.isSelf ? Alignment.centerRight : Alignment.centerLeft,
        padding: EdgeInsets.all(5.0),
        child: Text(message.text),
      );

  Widget _buildSmartReplyRow() {
    return Container(
      height: 30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildSmartReplyChips(),
          IconButton(
            icon: Icon(isSelfMode ? Icons.home : Icons.cloud),
            onPressed: () => setState(() {
              isSelfMode = !isSelfMode;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartReplyChips() => ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: _replies.map(_buildSmartReplyChip).toList(),
      );

  Widget _buildSmartReplyChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () => _addMessage(text),
    );
  }

  Widget _buildInputField() {
    return Container(
      height: 70,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: myController,
                onSubmitted: (message) => _addMessage(message),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _addMessage(myController.text),
          ),
        ],
      ),
    );
  }

  Future<void> _addMessage(String message) async {
    myController.clear();

    _textMessages.add(isSelfMode
        ? TextMessage.createForLocalUser(message, DateTime.now().millisecondsSinceEpoch)
        : TextMessage.createForRemoteUser(message, DateTime.now().millisecondsSinceEpoch));

    await updateSmartReplies();

    if (!mounted) return;

    setState(() {});
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
}
