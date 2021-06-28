
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

  String parseDate(DateTime date) {
    String formattedString = DateFormat('yyyy-MM-ddTKK:mm:00+02:00').format(date);
    return formattedString;
  }

  String formattingDate(DateTime date) {
    String formattedString = DateFormat('dd.MM.yyyy').format(date);
    return formattedString;
  }

  String formatBoxSize(BoxSize box) {
    String cur = box.toString().toUpperCase();
    String substring = cur.substring(cur.length - 1);
    return substring;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservierung bestätigen"),
      ) ,
      body: Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Card(
        margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text("Boxgröße:", style:
                  TextStyle(
                    fontWeight: FontWeight.bold
                  )),
                  SizedBox(width: 20,),
                  Text(formatBoxSize(lockerSize))
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("Startdatum:", style:
                    TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                  SizedBox(width: 8,),
                  Text(formattingDate(startDate)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("Enddatum:", style:
                    TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                  SizedBox(width: 16,),
                  Text(formattingDate(endDate))
                ],
              ),
              SizedBox(height: 10),
                Row(
                  children: [
                    Text("Straße:", style:
                    TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                    ),
                    SizedBox(width: 40,),

                    Expanded(
                      child: Text("${locker.streetName} ${locker.streetNumber}",
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,)
                    )
                  ],
                ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("Plz / Stadt:", style:
                    TextStyle(
                      fontWeight: FontWeight.bold,
                    ),),
                  SizedBox(width: 15),
                  Text("${locker.postcode} ${locker.city}"),
                ],
              )
            ],
          )
        ),
      ),
      SizedBox(height: 10,),
      ElevatedButton(
        child: Text("Submit"),
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

        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32)
          )
        )


      ),
    ])
      )
    );
  }
}


