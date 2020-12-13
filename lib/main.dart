import 'package:flutter/material.dart';
import 'ui/patentsMainScreen.dart';

void main() => runApp(Patents());

class Patents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PatentsMainScreen(),
      theme: ThemeData(primarySwatch: Colors.blueGrey),
    );
  }
}
