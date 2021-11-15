import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:telephony/telephony.dart';
import 'package:http/http.dart' as http;

onBackgroundMessage(SmsMessage message) async {
  
      var msg = {
            "title": "${message.address}",
            "body": "${message.body}",
            "sender": "${message.date}",
          };
      var body = jsonEncode(msg);
      var response = await http.post(
          Uri.parse(
              'https://expense-tracker-63c60-default-rtdb.firebaseio.com/message.json'),
          body: body,
          headers: {
            "Content-Type": "application/json"
          });
      debugPrint(response.toString());
      debugPrint("It was Called");
      
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _message = "";
  List<SmsMessage> txtMessage = <SmsMessage>[];
  List<SmsMessage> messages = <SmsMessage>[];
  final telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  onMessage(SmsMessage message) async {
    setState(() {
      _message = message.body ?? "Error reading message body.";
    });
  }

  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;
    txtMessage = await telephony.getInboxSms();
    for (var message in txtMessage) {
      _message = message.body ?? "No sms";
      var msg = {
            "title": "${message.address}",
            "body": "${message.body}",
            "sender": "${message.date}",
          };
      var body = jsonEncode(msg);
      var response = await http.post(
          Uri.parse(
              'https://expense-tracker-63c60-default-rtdb.firebaseio.com/message.json'),
          body: body,
          headers: {
            "Content-Type": "application/json"
          });
      var convert = json.decode(response.body);
      debugPrint(convert['name']);
      debugPrint("It was Called");
      setState(() {
        _message;
      });
    }

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text("Latest received SMS")),
          Text(_message),
        ],
      ),
    ));
  }

  onTextMessage(SmsMessage message) async {
    var response = await http.post(
        Uri.parse(
            'https://expense-tracker-63c60-default-rtdb.firebaseio.com/message.json'),
        body: {
          "title": "${message.address}",
          "body": "${message.body}",
          "sender": "${message.date}",
        },
        headers: {
          "Content-Type": "application/json"
        });
    debugPrint(response.toString());
    debugPrint("It was Called");
  }
}
