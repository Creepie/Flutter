import 'package:flutter/material.dart';
import 'package:flutter_database_ex/search.dart';

import 'CustomDatabase.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //CustomData is to add and see all db entries
      //Search is so filter the db
      home: Search()
      //CustomData(),
    );
  }
}
