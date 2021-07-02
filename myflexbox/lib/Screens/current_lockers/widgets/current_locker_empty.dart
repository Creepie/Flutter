import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("noch keine Einträge vorhanden", style: TextStyle(
        fontSize: 16,
        color: Colors.grey
      ),),
    );
  }

}