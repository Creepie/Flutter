import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final List<String> entries = <String>['A', 'B', 'C'];
final List<int> colorCodes = <int>[600, 500, 100];

class CurrentLockersPage extends StatelessWidget {

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
          GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext buildContext) {
                    return HistoryFilter();
                  });
            },
            child: Container(
              margin: EdgeInsets.only(
                right: 20,
                left: 10,
              ),
              child: Icon(Icons.filter_list),
            ),
          )
        ],
      ),
      body: HistoryList()
    );
  }
}

class HistoryFilter extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      padding: EdgeInsets.only(top: 20, bottom: 0, left: 0, right: 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      //color: Colors.amber,
        child: Column(
          children: [
            Text(
              "Filter Bookings",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black12,
                    width: 1.0,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black12,
                    width: 1.0,
                  ),
                  bottom: BorderSide(
                    color: Colors.black12,
                    width: 1.0,
                  ),
                ),
              ),
            )
          ],
        )
    );
  }
}


class HistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
    );
  }
}