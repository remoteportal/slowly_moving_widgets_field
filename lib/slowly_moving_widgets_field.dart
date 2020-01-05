library slowly_moving_widgets_field;

import 'package:flutter/material.dart';

class SlowlyMovingWidgetsField extends StatefulWidget {
  @override
  _SlowlyMovingWidgetsFieldState createState() =>
      _SlowlyMovingWidgetsFieldState();
}

class _SlowlyMovingWidgetsFieldState extends State<SlowlyMovingWidgetsField> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
//          width: 100,
//          height: 100,
          color: Colors.red,
        ),
        Positioned(
            child: Container(
              width: 80,
              height: 80,
              color: Colors.green,
            ),
            left: 0,
            top: 0),
        Positioned(
            child: Container(
              width: 80,
              height: 80,
              color: Colors.yellow,
            ),
            left: 100,
            top: 100),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}
