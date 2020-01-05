library slowly_moving_widgets_field;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SlowlyMovingWidgetsField extends StatefulWidget {
  @override
  _SlowlyMovingWidgetsFieldState createState() =>
      _SlowlyMovingWidgetsFieldState();
}

class Dude {
  double left;
  double top;
  double xdelta;
  double ydelta;
  Color color;
}

class _SlowlyMovingWidgetsFieldState extends State<SlowlyMovingWidgetsField> {
  int i = 0;
  List<Dude> list = [];
  Container back = Container(color: Colors.red);

  @override
  Widget build(BuildContext context) {
//    print("build");
    List<Widget> l = [back];
    list.forEach((d) {
//      print("dude: left=${d.left}");
      l.add(Positioned(
          child: Container(color: d.color, height: 100, width: 100),
          left: d.left,
          top: d.top));
      d.left += d.xdelta;
      d.top += d.ydelta;
    });
    return Stack(
      children: l,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
//    list = [
//      Positioned(
//        child: Container(
////          width: 100,
////          height: 100,
//          color: Colors.red,
//        ),
//        left: 0,
//        top: 0
//      ),
////      Positioned(
////          child: Container(
////            width: 80,
////            height: 80,
////            color: Colors.green,
////          ),
////          left: 0,
////          top: 0),
////      Positioned(
////          child: Container(
////            width: 80,
////            height: 80,
////            color: Colors.yellow,
////          ),
////          left: 100,
////          top: 100),
//    ];
//
//    for (int i = 0; i < 1; i++) {
////      list.forEach((w) {
////        w.key = UniqueKey()
////      });
//      list.add(Positioned(
//          child: Container(
//            color: Colors.black,
//            width: 80,
//            height: 80,
//          ),
//          left: 0,
//          key: UniqueKey(),
//          top: 0));
//    }

    var r = new Random();
    for (int i = 0; i < 10; i++) {
      Dude d = Dude();
      d.color = Color.fromARGB(
          255, 200 + r.nextInt(56), 200 + r.nextInt(56), 200 + r.nextInt(56));
      d.left = 0;
      d.top = 0;
      d.xdelta = r.nextDouble();
      d.ydelta = r.nextDouble();
      list.add(d);
    }

    Timer.periodic(Duration(milliseconds: 100 ~/ 60), (timer) {
//      print("i=$i");
      setState(() {
        i++;
      });
//      list[1].left = i;
    });
  }
}
