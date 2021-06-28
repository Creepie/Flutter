import 'package:flutter/material.dart';
import 'package:myflexbox/components/default_button.dart';
import 'package:myflexbox/cubits/rent_locker/rent_locker_state.dart';
import 'package:myflexbox/repos/models/locker.dart';

class SubmitPage extends StatelessWidget {
  final BoxSize lockerSize;
  final DateTime startDate;
  final DateTime endDate;
  final Locker locker;

  SubmitPage({this.lockerSize, this.startDate, this.endDate, this.locker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(lockerSize.toString()),
            Text(startDate.toString()),
            Text(endDate.toString()),
            Text("${locker.streetName} ${locker.streetNumber}"),
            Text("${locker.city} ${locker.postcode}"),
          ]
        )
      ),
    );
  }
}
