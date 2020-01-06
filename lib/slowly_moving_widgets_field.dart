library slowly_moving_widgets_field;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

final r = new Random();

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
  String id;

  double get right => left + width;

  double get bottom => top + height;

//  void position(double s_width, double s_height) {
//    left = r.nextInt((s_width - width).toInt()).toDouble();
//    top = r.nextInt((s_height - height).toInt()).toDouble();
//  }

  bool hit(Dude d) {
    return (d.left > left && d.left < right ||
            d.right > left && d.right < right) &&
        (d.top > top && d.top < bottom || d.bottom > top && d.bottom < bottom);
  }

  bool hitx(Dude d) {
//    return hit(d) && (d.xdelta > 0 && xdelta < 0 || xdelta > 0 && d.xdelta < 0);
    return false;
  }

  bool hity(Dude d) {
//    return hit(d) && (d.ydelta > 0 && ydelta < 0 || ydelta > 0 && d.ydelta < 0);
    return false;
  }

  String toString() => "dude $id: l=$left r=$right t=$top b=$bottom";
}

class _SlowlyMovingWidgetsFieldState extends State<SlowlyMovingWidgetsField> {
  double width = -1;
  double height = -1;

  double accelerate = .01;

  int cnt = 0;
  int hitCnt = 0;
  int hitxCnt = 0;
  int hityCnt = 0;
  int colorRotate = 0;
  int beats = 0;
  List<Dude> list = [];
  Container back = Container(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    if (height < 0) {
      width = MediaQuery.of(context).size.width;
      height = MediaQuery.of(context).size.height;

      for (int i = 0; i < 30; i++) {
        int attempt = 0;
        while (true) {
          attempt++;

          Dude d = Dude();
          switch (colorRotate) {
            case 0:
              d.color = Color.fromARGB(
                  255, 0, 200 + r.nextInt(56), 200 + r.nextInt(56));
              break;
            case 1:
              d.color = Color.fromARGB(
                  255, 200 + r.nextInt(56), 0, 200 + r.nextInt(56));
              break;
            case 2:
              d.color = Color.fromARGB(
                  255, 200 + r.nextInt(56), 200 + r.nextInt(56), 0);
              break;
          }

          colorRotate++;
          colorRotate %= 3;
          d.xdelta = (0.5 - (r.nextDouble() * 3)) / 1;
          d.ydelta = (0.5 - (r.nextDouble() * 0.5)) / 1;

//          d.position(width, height);
          d.left = r.nextInt((width - d.width).toInt()).toDouble();
          d.top = r.nextInt((height - d.height).toInt()).toDouble();

          bool add = true;
          if (list.length > 0) {
            list.forEach((d2) {
//              print("cr: $d2");
              if (d.hit(d2)) {
//                print("$i attempt $attempt: $d");
//                print("$i         $attempt: $d2");
                add = false;
              }
            });
          }

          if (add) {
            d.id = "$i";
            print("created: $d");
            list.add(d);
            break;
          }
        }
      }
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
          } else if (d.hity(d2)) {
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

    Timer.periodic(Duration(milliseconds: 1000 ~/ 30), (timer) {
      setState(() {
        beats++;
        if (beats % 10000 == 0) {
          print("10K beats");
        }
      });
    });
  }
}
