import 'dart:math';

import 'package:flutter/material.dart';
import 'package:slowly_moving_widgets_field/slowly_moving_widgets_field.dart';

final r = new Random();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Dude> list = [];

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(body: Center(child: SlowlyMovingWidgetsField(list: list))),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    int colorRotate = 0;
    Color color;
    for (int i = 0; i < 10; i++) {
      switch (colorRotate) {
        case 0:
          color =
              Color.fromARGB(255, 0, 200 + r.nextInt(56), 200 + r.nextInt(56));
          break;
        case 1:
          color =
              Color.fromARGB(255, 200 + r.nextInt(56), 0, 200 + r.nextInt(56));
          break;
        case 2:
          color =
              Color.fromARGB(255, 200 + r.nextInt(56), 200 + r.nextInt(56), 0);
          break;
      }

      colorRotate++;
      colorRotate %= 3;

      list.add(Dude(
        child: Container(
            child: Text("$i", style: TextStyle(fontSize: 40)),
            color: color,
            height: 50,
            width: 100),
        height: 50,
        width: 100,
      ));
    }
  }
}
