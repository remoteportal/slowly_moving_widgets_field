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
  double width = 50;
  double height = 50;
  double left = -1;
  double top = -1;
  double xdelta;
  double ydelta;
  Color color;

  double get right => left + width;
  double get bottom => top + height;

  bool impact(Dude d) {
    return d.left > left &&
        d.left + d.width < right &&
        d.top > top &&
        d.top + d.height < bottom;
  }
}

class _SlowlyMovingWidgetsFieldState extends State<SlowlyMovingWidgetsField> {
  final r = new Random();

  double width = -1;
  double height = -1;

  double accelerate = .01;

  int i = 0;
  List<Dude> list = [];
  Container back = Container(color: Colors.red);

  @override
  Widget build(BuildContext context) {
    if (height < 0) {
      width = MediaQuery.of(context).size.width;
      height = MediaQuery.of(context).size.height;
      list.forEach((d) {
        if (d.left < 0) {
          d.left = r.nextInt((width - d.width).toInt()).toDouble();
          d.top = r.nextInt((height - d.height).toInt()).toDouble();
        }
      });
    }

//    print("build");
    List<Widget> l = [back];
    list.forEach((d) {
//      print("dude: left=${d.left}");
      l.add(Positioned(
          child: Container(color: d.color, height: d.height, width: d.width),
          left: d.left,
          top: d.top));
      d.left += d.xdelta * accelerate;
      d.top += d.ydelta * accelerate;

      if (d.left < 0 || d.left + d.width > width) {
        d.xdelta *= -1;
      }

      if (d.top < 0 || d.top + d.height > height) {
        d.ydelta *= -1;
      }

      list.forEach((d2) {
        if (d != d2) {
//          print("diff");

          if (d.impact(d2)) {
            print("impact!");

            d.xdelta *= -1;
            d.ydelta *= -1;

            d2.xdelta *= -1;
            d2.ydelta *= -1;
          }
        }
      });

      if (accelerate < 1.0) {
        accelerate += 0.005;
      }
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

    for (int i = 0; i < 20; i++) {
      Dude d = Dude();
      d.color = Color.fromARGB(
          255, 200 + r.nextInt(56), 200 + r.nextInt(56), 200 + r.nextInt(56));
      d.xdelta = (0.5 - r.nextDouble()) / 1;
      d.ydelta = (0.5 - r.nextDouble()) / 1;
      list.add(d);
    }

    Timer.periodic(Duration(milliseconds: 1000 ~/ 30), (timer) {
      setState(() {
        i++;
      });
    });
  }
}
