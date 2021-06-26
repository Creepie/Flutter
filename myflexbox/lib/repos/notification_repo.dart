import 'package:firebase_database/firebase_database.dart';

import 'models/booking.dart';

class NotificationRepo {
  FirebaseDatabase database;
  DatabaseReference userDb;


  NotificationRepo() {
    database = FirebaseDatabase();
    userDb = database.reference().child('Users');
  }

  Future<void> notifyLockerShared(String fromId, String toId, Booking booking) async {
    //Messages messageFriend = new Messages(myUserName, "Added you as friend");
    //messageFriend.toJson()
    database.reference().child('Notifications').child(toId).push().set("");
  }
}