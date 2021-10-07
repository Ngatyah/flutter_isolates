import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isOn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        TextButton(
          onPressed: () {},
          child: const Text('Hello'),
        ),
        Center(
          child: Switch(
            value: isOn,
            onChanged: (value) {
              setState(() {
                isOn = value;
                if (isOn) {
                  debugPrint("Happy Day!!");
                }
              });
            },
          ),
        ),
      ],
    ));
  }
}
