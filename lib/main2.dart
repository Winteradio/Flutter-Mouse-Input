import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _message;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // animate();
  }

  void animate() {
    setState(() {
      _message = "Init";
      print("Animate");
    });
    Future.delayed(Duration(milliseconds: 500), () {
      animate();
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    setState(() {
      if (event is KeyDownEvent || event is KeyRepeatEvent) {
        _message = "${event.logicalKey.debugName}";
      } else if (event is KeyUpEvent) {
        _message = "Up ${event.logicalKey.debugName}";
      }else
      {
        _message = "NULL";
      }
    });
    return event.physicalKey == PhysicalKeyboardKey.keyA
        ? KeyEventResult.handled
        : KeyEventResult.ignored;
  }

  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);
    return Container(
      color: Colors.white,
      child: Focus(
        focusNode: _focusNode,
        onKeyEvent: _handleKeyEvent,
        child: Text('${_message}'),
      ),
    );
  }
}
