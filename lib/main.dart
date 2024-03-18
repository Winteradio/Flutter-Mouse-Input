import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mouse Event Detector'),
        ),
        body: MouseEvents(),
      ),
    );
  }
}

class MouseEvents extends StatefulWidget {
  @override
  _MouseEventsState createState() => _MouseEventsState();
}

enum Button { Left, Right, Wheel, NULL }

enum Action { Done, Click, Move }

class Mouse {
  Button button;
  Action action;
  Offset position;
  double wheel;

  Mouse(this.button, this.action, this.position, this.wheel);
}

class _MouseEventsState extends State<MouseEvents> {
  Mouse mouse = Mouse(Button.Left, Action.Done, Offset.zero, 0.0);
  Mouse newmouse = Mouse(Button.Left, Action.Done, Offset.zero, 0.0);
  Stopwatch watch = new Stopwatch();
  double Time = 0.0;
  String status = "";
  Color mycolor = const Color.fromARGB(137, 110, 104, 104);

  @override
  void initState() {
    super.initState();
    watch.start();
    Time = watch.elapsedMilliseconds.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          newmouse.button = Button.Wheel;
          newmouse.action = Action.Done;
          newmouse.position = Offset.zero;
          newmouse.wheel = event.scrollDelta.dy;
          calculate(watch.elapsedMilliseconds.toDouble(), newmouse);
          setState(() {});
        }
      },
      onPointerDown: (event) {
        if (event.buttons == 1) {
          newmouse.button = Button.Left;
        } else {
          newmouse.button = Button.Right;
        }
        newmouse.action = Action.Click;
        newmouse.position = event.position;
        newmouse.wheel = 0;
        calculate(watch.elapsedMilliseconds.toDouble(), newmouse);
        setState(() {});
      },
      onPointerMove: (event) {
        if (event.buttons == 1) {
          newmouse.button = Button.Left;
        } else {
          newmouse.button = Button.Right;
        }
        newmouse.action = Action.Move;
        newmouse.position = event.position;
        newmouse.wheel = 0;
        calculate(watch.elapsedMilliseconds.toDouble(), newmouse);
        setState(() {});
      },
      onPointerUp: (event) {
        // Up 할 때에는 button 구분 따로 없음
        newmouse.button = Button.NULL;
        newmouse.action = Action.Done;
        newmouse.position = event.position;
        newmouse.wheel = 0;
        calculate(watch.elapsedMilliseconds.toDouble(), newmouse);
        setState(() {});
      },
      child: Center(
        child: Container(
          width: 300,
          height: 300,
          color: mycolor,
          child: Text(status),
        ),
      ),
    );
  }

  void calculate(double time, Mouse othermouse) {
    String mousePrint = " ${Time} : ";

    switch (othermouse.action) {
      case Action.Done:
        {
          if (othermouse.button == Button.Wheel) {
            mousePrint += " Wheel Zoom ";
          } else if (othermouse.button == Button.NULL) {
            if (mouse.action == Action.Move) {
              if (mouse.button == Button.Left) {
                mousePrint += " Drag Done ";
              } else if (mouse.button == Button.Right) {
                mousePrint += " Pinch Done";
              }
            } else if (mouse.action == Action.Click) {
              mousePrint += " Click Done ";
            }
          }
          mouse.button = othermouse.button;
          mouse.action = othermouse.action;
          mouse.position = othermouse.position;
          mouse.wheel = othermouse.wheel;
          mycolor = const Color.fromARGB(137, 110, 104, 104);
          Time = time;
        }
        break;
      case Action.Click:
        {
          mycolor = const Color.fromARGB(50, 50, 50, 50);
          mouse.button = othermouse.button;
          mouse.action = othermouse.action;
          mouse.position = othermouse.position;
          mouse.wheel = othermouse.wheel;
          Time = time;
          mousePrint += " Scroll Click ";
        }
        break;
      case Action.Move:
        {
          if (othermouse.button != mouse.button) break;

          if (mouse.action == Action.Click && time - Time > 200.0) {
            if (othermouse.button == Button.Left) {
              mousePrint += " Drag Start ";
              mycolor = const Color.fromARGB(50, 150, 50, 200);
            } else if (othermouse.button == Button.Right) {
              mousePrint += " Pinch Start ";
              mycolor = const Color.fromARGB(50, 50, 150, 200);
            }
            mouse.button = othermouse.button;
            mouse.action = othermouse.action;
            mouse.position = othermouse.position;
            mouse.wheel = othermouse.wheel;
            Time = time;
          } else if (othermouse.action == mouse.action) {
            if (othermouse.button == Button.Left) {
              mousePrint += " Drag Update";
              mycolor = const Color.fromARGB(50, 255, 50, 255);
            } else if (othermouse.button == Button.Right) {
              mousePrint += " Pinch Update";
              mycolor = const Color.fromARGB(50, 50, 255, 255);
            }
            mouse.button = othermouse.button;
            mouse.action = othermouse.action;
            mouse.position = othermouse.position;
            mouse.wheel = othermouse.wheel;
            Time = time;
          }
        }
        break;
    }

    setState(() {
      status = mousePrint;
    });
    print("$mousePrint");
  }
}
