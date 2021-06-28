
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:myflexbox/components/default_button.dart';
import 'package:myflexbox/cubits/rent_locker/rent_locker_state.dart';
import 'package:myflexbox/repos/models/booking_request.dart';
import 'package:myflexbox/repos/models/locker.dart';
import 'package:myflexbox/repos/rent_locker_repository.dart';

class SubmitPage extends StatelessWidget {
  final BoxSize lockerSize;
  final DateTime startDate;
  final DateTime endDate;
  final Locker locker;

  SubmitPage({this.lockerSize, this.startDate, this.endDate, this.locker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(lockerSize: lockerSize, startDate: startDate, endDate: endDate, locker: locker),
    );
  }
}


class Body extends StatelessWidget {
  const Body({
    Key key,
    @required this.lockerSize,
    @required this.startDate,
    @required this.endDate,
    @required this.locker,
  }) : super(key: key);

  final BoxSize lockerSize;
  final DateTime startDate;
  final DateTime endDate;
  final Locker locker;

  String parseDate(DateTime date) {
    String formattedString = DateFormat('yyyy-MM-ddTKK:mm:00+02:00').format(date);
    return formattedString;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(lockerSize.toString()),
      Text(parseDate(startDate)),
      Text(parseDate(endDate)),
      Text("${locker.streetName} ${locker.streetNumber}"),
      Text("${locker.city} ${locker.postcode}"),
      TextButton(
        onPressed: () async{

          BookingRequest request = new BookingRequest(
              locker.lockerId,
              locker.compartments.first.compartmentId,
              parseDate(startDate),
              parseDate(endDate),
              FirebaseAuth.instance.currentUser.uid,
              "");

          var response = await RentLockerRepository().bookLocker(request);

          if (response != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("ok")));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("error")));
          }
        },
        child: Text("Submit"),
      )
    ]));
  }
}
