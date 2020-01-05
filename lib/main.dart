import 'package:flutter/material.dart';

import 'slowly_moving_widgets_field.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(body: Center(child: SlowlyMovingWidgetsField())),
    );
  }
}
