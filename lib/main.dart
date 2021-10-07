import 'package:flutter/material.dart';
import 'dart:async';
import 'package:telephony/telephony.dart';
import 'package:http/http.dart' as http;

onBackgroundMessage(SmsMessage message) async {
  var response = await http.post(
      Uri.parse(
          'https://react-http-548c4-default-rtdb.firebaseio.com/message.json'),
      body: {
        "id": 1,
        "title": "${message.address}",
        "body": "${message.body}",
        "sender": "${message.date}",
      },
      headers: {
        'Content-Type': 'application-json'
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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    final bool? result = await telephony.requestPhoneAndSmsPermissions;
    txtMessage = await telephony.getInboxSms();

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
          const Center (child: Text("Latest received SMS")),
         (txtMessage.first).equals(messages.first)? const Text('No Data'): TextButton(
            child: const Text('Hello'),
            onPressed: onTextMessage(txtMessage.first),
          )
        ],
      ),
    ));
  }

  onTextMessage(SmsMessage message) async {
    var response = await http.post(
        Uri.parse(
            'https://react-http-548c4-default-rtdb.firebaseio.com/message.json'),
        body: {
          "id": 1,
          "title": "${message.address}",
          "body": "${message.body}",
          "sender": "${message.date}",
        },
        headers: {
          'Content-Type': 'application-json'
        });
    debugPrint(response.toString());
    debugPrint("It was Called");
  }
}
