import 'package:flutter/material.dart';
import 'package:slowly_moving_widgets_field/slowly_moving_widgets_field.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(body: Center(child: SlowlyMovingWidgetsField())),
    );
  }
}
