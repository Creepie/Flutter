import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/Screens/current_lockers/widgets/BottomCard.dart';
import 'package:myflexbox/Screens/current_lockers/widgets/TopCard.dart';
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
              return EmptyScreen();
            } else {
              return RentLockerListLoadingIndicator();
            }
          },
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
}


class HistoryFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = 340.0;
    return Container(
        height: height,
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
              child: Row(
                children: [
                  BoxPickerSquare(width: width,filterType: "nicht Eingelagert", height: height,assetPath: "assets/images/status_booking_created.png"),
                  BoxPickerSquare(width: width,filterType: "Abgeholt", height: height,assetPath: "assets/images/status_collected.png",),
                ],
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
              child: Row(
                children: [
                  BoxPickerSquare(width: width,filterType: "nicht Abgeholt", height: height,assetPath: "assets/images/status_not_collected.png",),
                  BoxPickerSquare(width: width,filterType: "Abgebrochen", height: height,assetPath: "assets/images/status_booking_cancelled.png",),
                ],
              ),
            )
          ],
        ));
  }
}

class BoxPickerSquare extends StatelessWidget{
  final double width;
  final String filterType;
  final double height;
  final String assetPath;

  const BoxPickerSquare({Key key, this.width, this.filterType, this.height, this.assetPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        width: width * 0.5,
        height: height *0.4,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(

          border: Border(
            right: BorderSide(
              color: Colors.black12,
              width: 1.0,
            ),
          ),
        ),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  filterType,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                Image.asset(
                  assetPath,
                  width: 65,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}


class EmptyScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Center();
  }

}








