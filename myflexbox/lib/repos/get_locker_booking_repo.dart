import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:myflexbox/repos/models/booking.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'models/user.dart';

class GetLockerBooking {
  FirebaseDatabase database;
  DatabaseReference shareDB;

  GetLockerBooking() {
    database = FirebaseDatabase();
    shareDB = database.reference().child('share');
  }

  ///the [apiKey] is needed in each api call and is stored in the auth header
  final String apiKey =
      "Basic 77+977+90IcGI++/vVQhWjDvv73vv70R77+9Nh/vv70yVTIoe++/vRDvv71WVwBd77+9";

  ///the [baseUrl] is needed in each api call for building the url endpoint
  final String baseUrl = "https://dev-myflxbx-rest.azurewebsites.net";

  ///this method Retrieves a List of [Booking] where the externalId (Firebase Uid) matches
  Future<List<Booking>> getBookings(String externalId) async {
    var url = '$baseUrl/api/1/bookings?externalId=${""}';
    final response = await http.get(
      Uri.parse(url),
      headers: {HttpHeaders.authorizationHeader: apiKey},
    );

    //Get the Bookings of the user
    if (response.statusCode == 200) {
      List<Booking> userBookings = json
          .decode(response.body)['bookings']
          .map((data) => Booking.fromJson(data))
          .toList()
          .cast<Booking>();
      //Get the Bookings that are Shared  to the user
      List<Booking> sharedBookings = await getSharedBookingsFrom(externalId);
      //Transform the Bookings of the user to BookingsTo if they are shared
      await getSharedBookingsTo(externalId, userBookings);
      //Add the own bookings to the bookings, shared by the user
      sharedBookings.addAll(userBookings);
      return sharedBookings;
    } else {
      // If the server did not return a 200 OK response,
      return null;
    }
  }

  //Transforms Bookings in the passed list to BookingsTo if the user with the
  // externalId has share some of the lockers with others.
  Future<void> getSharedBookingsTo(
      String externalID, List<Booking> bookingList) async {
    DataSnapshot toF =
        await shareDB.orderByChild("from").equalTo(externalID).once();
    Map<dynamic, dynamic> to = toF.value;
    if (to != null) {
      for (int i = 0; i < bookingList.length; i++) {
        try {
          String bId = bookingList[i].bookingId.toString();
          if (to.containsKey(bId)) {
            String toId = to[bId]['to'] as String;
            DBUser fromUser = toId.startsWith("+43")
                ? await getUserWithNumber(toId)
                : await getUser(toId);
            bookingList[i] = BookingTo(bookingList[i], fromUser);
          }
        } catch (e) {
          print(e.toString());
        }
      }
    }
  }

  Future<DBUser> getUserWithNumber(String number) async {
    List<Contact> _contacts = (await ContactsService.getContactsForPhone(
      number,
      withThumbnails: false,
      photoHighResolution: false,
    ))
        .toList();
    if (_contacts.isEmpty) {
      return DBUser("", number, number, null, []);
    } else {
      String name = _contacts[0].displayName;
      return DBUser("", name, number, null, []);
    }
  }

  //Creates a List with BookingsFrom, that are shared to the user with the
  // external id
  Future<List<Booking>> getSharedBookingsFrom(String externalID) async {
    //Get Firebase Shares as List
    DataSnapshot fromF =
        await shareDB.orderByChild("to").equalTo(externalID).once();
    Map<dynamic, dynamic> from = fromF.value;
    //For each -> get Booking
    if (from != null) {
      List<Booking> fromBookingList = [];
      await Future.forEach(from.entries, ((entry) async {
        Booking booking = await getBooking(entry.key);
        if (booking != null) {
          String fromId = entry.value['from'] as String;
          DBUser fromUser = await getUser(fromId);
          BookingFrom bookingFrom = BookingFrom(booking, fromUser);
          //booking.share = Share.fromJson(entry.value, booking.bookingId);
          fromBookingList.add(bookingFrom);
        }
      }));
      return fromBookingList;
    } else {
      return [];
    }
  }

  ///this method Retrieves one [Booking] with a given bookingId
  Future<Booking> getBooking(String bookingId) async {
    var url = '$baseUrl/api/1/booking?bookingId=${bookingId}';
    final response = await http.get(
      Uri.parse(url),
      headers: {HttpHeaders.authorizationHeader: apiKey},
    );

    if (response.statusCode == 200) {
      return Booking.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      return null;
    }
  }

  ///this method deletes one [Booking] with a given bookingId
  Future<bool> deleteBooking(String bookingId) async {
    var url = '$baseUrl/api/1/booking?bookingId=${bookingId}';
    final response = await http.delete(
      Uri.parse(url),
      headers: {HttpHeaders.authorizationHeader: apiKey},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> shareBooking(String toId, String fromId, int bookingID) async {
    shareDB
        .child(bookingID.toString())
        .set({"to": toId.toString(), "from": fromId.toString()});
    //TODO check if successful
  }

  Future<DBUser> getUser(String uid) async {
    DataSnapshot user =
        await database.reference().child('Users').child(uid).once();
    if (user.value != null) {
      return Future.value(DBUser.fromJson(user.value));
    } else {
      return DBUser("", uid, uid, null, []);
    }
  }

  Future<MemoryImage> getQR(int id) async {
    var url = '$baseUrl/api/1/qr?code=${id}';
    final response = await http.get(
      Uri.parse(url),
      headers: {HttpHeaders.authorizationHeader: apiKey},
    );

    if (response.statusCode == 200) {
      return MemoryImage(response.bodyBytes);
    } else {
      // If the server did not return a 200 OK response,
      return null;
    }
  }

  Future<void> deleteShare(String bookingID) async {
    print(bookingID);
    await shareDB.child(bookingID).remove();
  }
}
