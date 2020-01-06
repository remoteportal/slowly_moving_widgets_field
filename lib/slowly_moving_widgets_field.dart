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

  bool hit(Dude d) {
    return d.left > left && d.left < right ||
        d.right > left && d.right < right && d.top > top && d.top < bottom ||
        d.bottom > top && d.bottom < bottom;
  }

  bool hitx(Dude d) {
    return hit(d) && (d.xdelta > 0 && xdelta < 0 || xdelta > 0 && d.xdelta < 0);
  }

  bool hity(Dude d) {
    return hit(d) && (d.ydelta > 0 && ydelta < 0 || ydelta > 0 && d.ydelta < 0);
  }
}

class _SlowlyMovingWidgetsFieldState extends State<SlowlyMovingWidgetsField> {
  final r = new Random();

  double width = -1;
  double height = -1;

  double accelerate = .01;

  int cnt = 0;
  int hitCnt = 0;
  int hitxCnt = 0;
  int hityCnt = 0;
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
          cnt++;
//          print("diff $cnt");

//          if (d.hit(d2)) {
//            hitCnt++;
//            print("hit $hitCnt");
//
//            d.xdelta *= -1;
//            d.ydelta *= -1;
//
//            d2.xdelta *= -1;
//            d2.ydelta *= -1;
//          }

          if (d.hitx(d2)) {
            hitxCnt++;
//            print("hitx $hitxCnt");

            d.xdelta *= -1;
            d2.xdelta *= -1;
          }

          if (d.hity(d2)) {
            hityCnt++;
//            print("hity $hityCnt");

            d.ydelta *= -1;
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

    for (int i = 0; i < 10; i++) {
      int attempt = 0;
      while (true) {
        attempt++;
        Dude d = Dude();
        d.color = Color.fromARGB(
            255, 200 + r.nextInt(56), 200 + r.nextInt(56), 200 + r.nextInt(56));
        d.xdelta = (0.5 - (r.nextDouble() * 2 + 0.1)) / 1;
        d.ydelta = (0.5 - (r.nextDouble() + 0.1)) / 1;

        bool add = true;
        if (list.length > 0) {
          list.forEach((d2) {
            if (d.hit(d2)) {
              print("attempt $attempt: creation hit");
              add = false;
            }
          });
        }

        if (add) {
          list.add(d);
          break;
        }
      }
    }

    Timer.periodic(Duration(milliseconds: 1000 ~/ 30), (timer) {
      setState(() {
        i++;
      });
    });
  }
}
