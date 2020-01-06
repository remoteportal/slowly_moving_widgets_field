library slowly_moving_widgets_field;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

final r = new Random();

/*
 * returns a Stack().
 *
 * add a slight random on every impact
 */
class SlowlyMovingWidgetsField extends StatefulWidget {
  final List<Widget> list;

  SlowlyMovingWidgetsField({@required this.list}) : assert(list != null);

  @override
  _SlowlyMovingWidgetsFieldState createState() =>
      _SlowlyMovingWidgetsFieldState();
}

class Dude {
  Dude(this.widget);

  Widget widget;
  double width = 50; //HELP
  double height = 50;
  double left = -1;
  double top = -1;
  double xdelta;
  double ydelta;
  String id;

  double get right => left + width;
  double get bottom => top + height;

  bool hit(Dude d) {
    return (d.left > left && d.left < right ||
            d.right > left && d.right < right) &&
        (d.top > top && d.top < bottom || d.bottom > top && d.bottom < bottom);
  }

  bool hitx(Dude d) {
    return hit(d) && (d.xdelta > 0 && xdelta < 0 || xdelta > 0 && d.xdelta < 0);
//    return false;
  }

  bool hity(Dude d) {
    return hit(d) && (d.ydelta > 0 && ydelta < 0 || ydelta > 0 && d.ydelta < 0);
//    return false;
  }

  String toString() => "$id";
  String toDump() => "dude $id: l=$left r=$right t=$top b=$bottom";
}

class _SlowlyMovingWidgetsFieldState extends State<SlowlyMovingWidgetsField> {
  double width = -1;
  double height = -1;

  double accelerate = .01;
  bool accelerated = false;

  int createHits = 0;
  int longestRun = 0;
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

      for (int i = 0; i < list.length; i++) {
        int attempt = 0;
        while (true) {
          if (++attempt > longestRun) {
            longestRun = attempt;
          }

          Dude d = Dude(widget.list[i]);

          d.xdelta = (0.5 - (r.nextDouble() * 3)) / 1;
          d.ydelta = (0.5 - (r.nextDouble() * 0.5)) / 1;

          d.left = r.nextInt((width - d.width).toInt()).toDouble();
          d.top = r.nextInt((height - d.height).toInt()).toDouble();

          bool add = true;
          if (list.length > 0) {
            list.forEach((d2) {
//              print("cr: $d2");
              if (d.hit(d2)) {
                createHits++;
//                print("$i attempt $attempt: $d");
//                print("$i         $attempt: $d2");
                add = false;
              }
            });
          }

          if (add) {
            d.id = "$i";
//            print("created: $d");
            list.add(d);
            break;
          }
        }
      }
    }

    List<Widget> l = [back];
    list.forEach((d) {
//      print("dude: left=${d.left}");
      l.add(Positioned(child: d.widget, left: d.left, top: d.top));

      d.left += d.xdelta * accelerate;
      d.top += d.ydelta * accelerate;

      list.forEach((d2) {
        if (d != d2) {
          if (d.hit(d2)) {
            if (d.xdelta > 0 && d2.xdelta < 0) {
              d.xdelta *= -1;
              d2.xdelta *= -1;
//              print("x: both $d $d2");
            } else if ((d.xdelta > 0 &&
                    d2.xdelta > 0 &&
                    d.xdelta > d2.xdelta) ||
                (d.xdelta < 0 && d2.xdelta < 0 && d.xdelta < d2.xdelta)) {
//              print("x: $d > $d2");
              d.xdelta *= -1;
            } else if (d.xdelta > 0 && d2.xdelta > 0 && d.xdelta < d2.xdelta) {
//              print("x: $d2 > $d");
              d2.xdelta *= -1;
            }

            if (d.ydelta > 0 && d2.ydelta < 0) {
              d.ydelta *= -1;
              d2.ydelta *= -1;
//              print("y: both $d $d2");
            } else if ((d.ydelta > 0 &&
                    d2.ydelta > 0 &&
                    d.ydelta > d2.ydelta) ||
                (d.ydelta < 0 && d2.ydelta < 0 && d.ydelta < d2.ydelta)) {
//              print("y: $d > $d2");
              d.ydelta *= -1;
            } else if (d.ydelta > 0 && d2.ydelta > 0 && d.ydelta < d2.ydelta) {
//              print("y: $d2 > $d");
              d2.ydelta *= -1;
            }
          }
        }
      });

      if (d.left < 0) {
        d.left = 0;
        d.xdelta = d.xdelta.abs();
      }

      if (d.right > width) {
        d.left = width - d.width;
        d.xdelta = -d.xdelta.abs();
      }

      if (d.top < 0) {
        d.top = 0;
        d.ydelta = d.ydelta.abs();
      }

      if (d.bottom > height) {
        d.top = height - d.height;
        d.ydelta = -d.ydelta.abs();
      }
    });

    if (!accelerated) {
      if (accelerate > 1.0) {
        accelerated = true;
        accelerate = 1.0;
        print("accelerated: createHits=$createHits longestRun=$longestRun");
      } else {
        accelerate += 0.01;
      }
    }

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
