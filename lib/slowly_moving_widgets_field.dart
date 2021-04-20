library slowly_moving_widgets_field;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

final _r = new Random();

/// A widget that moves arbitrary widgets over a background space.
///
/// Implemented using a Stack() widget.
class SlowlyMovingWidgetsField extends StatefulWidget {
  final List<Moving> list;
  final double? collisionAmount;

  SlowlyMovingWidgetsField({required this.list, this.collisionAmount});

  @override
  _SlowlyMovingWidgetsFieldState createState() =>
      _SlowlyMovingWidgetsFieldState();
}

/// Wrapper for each user widget that moves.  Each user widget must be wrapped in a Container().
class Moving {
  Moving({required this.child, required this.width, required this.height});

  /// User widget
  Container child;

  /// Width of widget; used for collision detection
  double width;

  /// Height of widget; used for collision detection
  double height;

  /// x-position in field
  double left = -1;

  /// y-position in field
  double top = -1;

  /// amount of horizontal distance moved per tick; can be negative
  late double xdelta;

  /// amount of veritical distance moved per tick; can be negative
  late double ydelta;

  /// unique of each moving widget; only used for logging
  String? id;

  double get right => left + width;

  double get bottom => top + height;

  /// collision detection with another user widget
  bool hit(Moving d) {
    return (d.left > left && d.left < right ||
            d.right > left && d.right < right) &&
        (d.top > top && d.top < bottom || d.bottom > top && d.bottom < bottom);
  }

  /// collision with horizontal movement
  bool hitx(Moving d) {
    return hit(d) && (d.xdelta > 0 && xdelta < 0 || xdelta > 0 && d.xdelta < 0);
//    return false;
  }

  /// collision with vertical movement
  bool hity(Moving d) {
    return hit(d) && (d.ydelta > 0 && ydelta < 0 || ydelta > 0 && d.ydelta < 0);
//    return false;
  }

  String toString() => "$id";

  String toDump() =>
      "moving $id: w=$width h=$height: l=$left r=$right t=$top b=$bottom (xd=$xdelta yd=$ydelta)";
}

class _SlowlyMovingWidgetsFieldState extends State<SlowlyMovingWidgetsField> {
  double width = -1;
  double height =
      -1; // don't know size of "moving field" until context is passed during build()

  double accelerate = .01;
  bool accelerated = false;

  int createHits = 0;
  int longestRun = 0;
  int hitCnt = 0;
  int hitxCnt = 0;
  int hityCnt = 0;
  int colorRotate = 0;
  int beats = 0;
  List<Moving> list = [];
  Container back = Container(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    // on first pass get screen dimensions and build list of moving widgets
    if (height < 0) {
//      print("initialize: count=${widget.list.length}");
      width = MediaQuery.of(context).size.width;
      height = MediaQuery.of(context).size.height;

      assert(width > 100); //ARB//TODO//TRAVESTY
      assert(height > 100);

      for (int i = 0; i < widget.list.length; i++) {
//        print("placing moving #$i in field");
        Moving d = widget.list[i];

        d.xdelta = (0.5 - (_r.nextDouble() * 3)) /
            1; //TODO: ensure not too close to zero
        d.ydelta = (0.5 - (_r.nextDouble() * 0.5)) / 1;

        int attempt = 0;

//        print("${d.toDump()}");

        while (true) {
          // keep trying until find a spot to create the new widget in a place that isn't already occupied by existing widget
          if (++attempt > longestRun) {
            longestRun = attempt;
          }

          d.left = _r.nextInt((width - d.width).toInt()).toDouble();
          d.top = _r.nextInt((height - d.height).toInt()).toDouble();

          bool add = true;
          if (widget.collisionAmount != null && list.length > 0) {
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

    // create new list of Positioned() widgets FOR EACH BUILD.
    List<Widget> l = [back];
    list.forEach((d) {
//      print("moving: left=${d.left}");
      l.add(Positioned(child: d.child, left: d.left, top: d.top));

      d.left += d.xdelta * accelerate;
      d.top += d.ydelta * accelerate;

      if (widget.collisionAmount != null) {
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
              } else if (d.xdelta > 0 &&
                  d2.xdelta > 0 &&
                  d.xdelta < d2.xdelta) {
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
              } else if (d.ydelta > 0 &&
                  d2.ydelta > 0 &&
                  d.ydelta < d2.ydelta) {
//              print("y: $d2 > $d");
                d2.ydelta *= -1;
              }
            }
          }
        });
      }

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
//        print("accelerated: createHits=$createHits longestRun=$longestRun");
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
        beats++; // force rebuilds 30 frames per second
        if (beats % 10000 == 0) {
          print("10K beats");
        }
      });
    });
  }
}
