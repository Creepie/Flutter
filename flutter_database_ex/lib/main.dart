import 'package:flutter/material.dart';


import 'CustomDatabase.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //CustomData is to add and see all db entries
      //Search is so filter the db
      home: CustomData(),
    );
  }
}
