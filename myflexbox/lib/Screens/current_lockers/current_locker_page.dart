import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentLockersPage extends StatelessWidget {

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.white,
        title: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey,
                width: 1
            ),
            borderRadius: BorderRadius.all(
                Radius.circular(20),
            )
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(
              right: 20,
              left: 10,
            ),
            child: Icon(Icons.filter_list),
          )
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Colors.amber[colorCodes[index]],
            child: Center(child: Text(entries[index]),),
          );
      },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}

class HistoryList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

  }

}