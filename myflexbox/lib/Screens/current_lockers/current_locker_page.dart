import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/Screens/rent_locker/widgets/rent_locker_list_view.dart';
import 'package:myflexbox/config/app_router.dart';
import 'package:myflexbox/cubits/current_locker/current_locker_cubit.dart';
import 'package:myflexbox/cubits/current_locker/current_locker_state.dart';
import 'package:myflexbox/cubits/locker_detail/locker_detail_cubit.dart';
import 'package:myflexbox/cubits/locker_detail/locker_detail_state.dart';
import 'package:myflexbox/repos/get_locker_booking_repo.dart';
import 'package:myflexbox/repos/models/booking.dart';
import 'package:timelines/timelines.dart';
import 'package:myflexbox/Screens/current_locker_detail/current_locker_detail.dart';

class CurrentLockersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                )),
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
              onTap: () {
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
        body: BlocBuilder<CurrentLockerCubit, CurrentLockerState>(
          builder: (context, state) {
            if (state is CurrentLockerList) {
              return HistoryList();
            } else if (state is CurrentLockerEmpty) {
              return Center();
            } else {
              return RentLockerListLoadingIndicator();
            }
          },
        ));
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
        ));
  }
}

class HistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentLockerCubit, CurrentLockerState>(
        builder: (context, state) {
      List<Booking> bookingList = [];
      if (state is CurrentLockerList) {
        bookingList = (state).bookingList;
      }
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: bookingList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: HistoryTile(booking: bookingList[index]),
          );
        },
      );
    });
  }
}

class HistoryTile extends StatelessWidget {
  final Booking booking;

  const HistoryTile({Key key, this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Card(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet<dynamic>(
                  isScrollControlled: true,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15)
                    ),
                  ),
                  builder: (BuildContext buildContext) {
                    var currentLockerCubit = context.read<CurrentLockerCubit>();
                    return BlocProvider(
                      create: (context) =>
                          LockerDetailCubit(booking, currentLockerCubit.repo, currentLockerCubit)..getPosition(),
                      child: CurrentLockerDetailScreen(),
                    );
                  });
            },
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  TopCard(booking: booking,),

                  BottomCard(booking: booking,)
                ],
              )
            ),
          ),
          //TimeLine(),
          const Divider(
            height: 1,
            thickness: 1,
            indent: 5,
            endIndent: 5,
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet<dynamic>(
                  isScrollControlled: true,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15)
                    ),
                  ),
                  builder: (BuildContext buildContext) {
                    var currentLockerCubit = context.read<CurrentLockerCubit>();
                    return BlocProvider(
                      create: (context) =>
                          LockerDetailCubit(booking, currentLockerCubit.repo, currentLockerCubit)..showQR()..getPosition(),
                      child: CurrentLockerDetailScreen(),
                    );
                  });
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width * 0.6,
                    child: Text(
                      getQRCodeText(booking),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      showModalBottomSheet<dynamic>(
                          isScrollControlled: true,
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15)
                            ),
                          ),
                          builder: (BuildContext buildContext) {
                            var currentLockerCubit = context.read<CurrentLockerCubit>();
                            return BlocProvider(
                              create: (context) =>
                              LockerDetailCubit(booking, currentLockerCubit.repo, currentLockerCubit)..showQR()..getPosition(),
                              child: CurrentLockerDetailScreen(),
                            );
                          });
                    },
                    icon: Icon(
                      Icons.qr_code,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  ///this method is to set the right text left to the QR Code
  String getQRCodeText(Booking booking){
    if(booking is BookingFrom){
      return "Paket abholen";
    } else if(booking is BookingTo && booking.state == "BOOKING_CREATED"){
      return "Paket einlegen";
    } else {
      return "Paket entnehmen";
    }
  }

  String getCreator(Booking booking){
    var myUserId = FirebaseAuth.instance.currentUser.displayName;
    if(booking is BookingTo){
      return "Ich";
    } else if(booking is BookingFrom){
      return (booking).fromUser.name;
    } else {
      return "Ich";
    }
  }
  
  String getSharedName(Booking booking) {
    var myUserId = FirebaseAuth.instance.currentUser.displayName;
    String txt = "";
    if (booking is BookingFrom) {
      txt = (booking as BookingFrom).fromUser.name;
    }
    if (txt.isNotEmpty) {
      return "Mir";
    } else {
      return txt;
    }
  }
}

class TimeLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Timeline.tileBuilder(
      builder: TimelineTileBuilder.fromStyle(
        contentsAlign: ContentsAlign.alternating,
        contentsBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('T $index'),
        ),
        itemCount: 2,
      ),
    );
  }
}

class TopCard extends StatelessWidget{
  final Booking booking;


  const TopCard({Key key, this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
   return Row(
     children: [
       SizedBox(
         width: width * 0.60,
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
               getStateText(),
               style: TextStyle(
                   fontSize: 18,
                   color: booking is BookingFrom
                       ? Colors.lightGreen
                       : booking is BookingTo
                       ? Colors.yellow
                       : Colors.black87),
             ),
             SizedBox(
               height: 5,
             ),
             Row(
               children: [
                 Text(
                   "von",
                   style: TextStyle(color: Colors.black54),
                 ),
                 SizedBox(
                   width: 5,
                 ),
                 Text(convertDate(booking.startTime))
               ],
             ),
             SizedBox(
               height: 5,
             ),
             Row(
                 children: [
                   Text(
                     "bis",
                     style: TextStyle(color: Colors.black54),
                   ),
                   SizedBox(
                     width: 5,
                   ),
                   Text(convertDate(booking.endTime)),
                 ]
             ),
           ],
         ),
       ),
       Spacer(),
       Column(
         children: [
           Image.asset(
             getImagePath(),
             width: 80,
           ),
           Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0))
         ],
       )
     ],
   );
  }

  ///this method is to set the header state string
  String getStateText(){
    String txt = "";
    if (booking.state == "BOOKING_CREATED") {
      txt = "Bereit zu Einlagerung";
    } else if (booking.state == "COLLECTED") {
      txt = "Abgeholt";
    } else if (booking.state == "NOT_COLLECTED") {
      txt = "nicht Abgeholt";
    } else {
      txt = "Abgebrochen";
    }
    return txt;
  }

  ///this method is to get the right image for each booking
  String getImagePath(){
    String stateImageSrc = "";
    if (booking.state == "BOOKING_CREATED") {
      stateImageSrc = "assets/images/status_booking_created.png";
    } else if (booking.state == "COLLECTED") {
      stateImageSrc = "assets/images/status_collected.png";
    } else if (booking.state == "NOT_COLLECTED") {
      stateImageSrc = "assets/images/status_not_collected.png";
    } else {
      stateImageSrc = "assets/images/status_booking_cancelled.png";
    }
    return stateImageSrc;
  }

  String convertDate(String date) {
    var time = DateTime.parse(date);
    return time.day.toString() +
        "." +
        time.month.toString() +
        "." +
        time.year.toString();
  }

}


class BottomCard extends StatelessWidget{
  final Booking booking;

  const BottomCard({Key key, this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            children: [
              Text(
                "Ersteller",
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(
                width: 5,
              ),
              Text(getCreator()),
            ]
        ),
        SizedBox(
          height: 5,
        ),
        Row(
            children: [
              Text(
                "Geteilt mit",
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(
                width: 5,
              ),
              Text(getSharedName()),
            ]
        ),
      ],
    );
  }

  String getSharedName() {
    String txt = "";
    if (booking is BookingFrom) {
      txt = (booking as BookingFrom).fromUser.name;
    }
    if (txt.isNotEmpty) {
      return "Mir";
    } else {
      return txt;
    }
  }

  String getCreator(){
    var myUserId = FirebaseAuth.instance.currentUser.displayName;
    if(booking is BookingTo){
      return "Ich";
    } else if(booking is BookingFrom){
      return (booking as BookingFrom).fromUser.name;
    } else {
      return "Ich";
    }
  }
}
