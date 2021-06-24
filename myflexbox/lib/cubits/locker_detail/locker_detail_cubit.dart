import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/cubits/current_locker/current_locker_cubit.dart';
import 'package:myflexbox/repos/models/booking.dart';
import 'package:myflexbox/repos/models/user.dart';
import 'package:myflexbox/repos/user_repo.dart';
import 'locker_detail_state.dart';
import 'package:myflexbox/repos/get_locker_booking_repo.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'dart:io';

class LockerDetailCubit extends Cubit<LockerDetailState> {
  final GetLockerBooking currentLockersRepository;
  final UserRepository userRepository = new UserRepository();
  final CurrentLockerCubit currentLockerCubit;

  LockerDetailCubit(Booking booking, this.currentLockersRepository, this.currentLockerCubit)
      : super(LockerDetailStateDefault(booking));

  void showQR() async {
    emit(LockerDetailStateLoading(state.booking));
    MemoryImage image =
        await currentLockersRepository.getQR(state.booking.compartmentId);
    emit(LockerDetailStateQR(state.booking, image));
  }

  Future<void> showShare(List<String> favoriteIds) async {
    emit(LockerDetailStateShare(state.booking, null, null, null, null, ""));
    var favorites = await getFavorites(favoriteIds);
    getContacts(favorites);
  }

  void filterShare(String filter) async {
    if (state is LockerDetailStateShare) {
      var shareState = state as LockerDetailStateShare;
      List<DBUser> filteredContacts = [];
      List<DBUser> filteredFavorites = [];

      if (filter.isNotEmpty && shareState.favorites != null) {
        for (DBUser user in shareState.favorites) {
          if (user.name.toLowerCase().contains(filter.toLowerCase()) ||
              user.number
                  .toString()
                  .toLowerCase()
                  .contains(filter.toLowerCase())) {
            filteredFavorites.add(user);
          }
        }
      } else {
        filteredFavorites = shareState.favorites;
      }
      if (filter.isNotEmpty && shareState.contacts != null) {
        for (DBUser user in shareState.contacts) {
          if (user.name.toLowerCase().contains(filter.toLowerCase()) ||
              user.number
                  .toString()
                  .toLowerCase()
                  .contains(filter.toLowerCase())) {
            filteredContacts.add(user);
          }
        }
      } else {
        filteredContacts = shareState.contacts;
      }
      emit(LockerDetailStateShare(shareState.booking, shareState.contacts,
          filteredContacts, shareState.favorites, filteredFavorites, filter));
    }
  }

  Future<List<DBUser>> getFavorites(List<String> favoriteIds) async {
    List<DBUser> favorites = [];
    for (final favoriteID in favoriteIds) {
      favorites.add(await userRepository.getUserFromDB(favoriteID));
    }
    return favorites;
  }

  void getContacts(List<DBUser> favList) async {
    List<Contact> _contacts = (await ContactsService.getContacts(
      withThumbnails: false,
      photoHighResolution: false,
    ))
        .toList();

    List<DBUser> contactList = [];

    //Loop all contacts
    for (int i = 0; i < _contacts.length; i++) {
      //Loop all numbers of a contact
      var contactNumbers = _contacts[i].phones.toList();
      for (int j = 0; j < _contacts[i].phones.length; j++) {
        var isFavorite = false;
        var contactNumber = contactNumbers[j].value.replaceAll(" ", "");
        //check if the number is duplicated for the contact
        if (!(j > 0 &&
            contactNumbers[j - 1].value.replaceAll(" ", "") == contactNumber)) {
          //check if the contact is a favorite
          for (int t = 0; t < favList.length; t++) {
            //if yes, add the name to the favorite
            if (favList[t].number == contactNumber) {
              isFavorite = true;
              favList[t].name += " (" + _contacts[i].displayName + ")";
            }
          }
          //if not, add contact to the list
          if (!isFavorite) {
            contactList.add(
                DBUser("", _contacts[i].displayName, contactNumber, null, []));
          }
        }
      }
    }

    if (state is LockerDetailStateShare) {
      var shareState = state as LockerDetailStateShare;
      emit(LockerDetailStateShare(shareState.booking, contactList, contactList,
          favList, favList, shareState.filter));
    }
  }

  void showDefault() {
    emit(LockerDetailStateDefault(state.booking));
  }

  Future<void> deleteShare() async {
    emit(LockerDetailStateLoading(state.booking));
    await currentLockersRepository.deleteShare(state.booking.bookingId.toString());
    currentLockerCubit.loadData();
    Booking updatedBooking = Booking.fromBooking(state.booking);
    emit(LockerDetailStateDefault(updatedBooking));
  }

  void shareViaFlexBox(DBUser userTo, DBUser userFrom) async {
    String toID = userTo.uid == null ? userTo.number : userTo.uid;
    String fromID = userFrom.uid == null ? userFrom.number : userFrom.uid;

    emit(LockerDetailStateLoading(state.booking));
    await currentLockersRepository.shareBooking(
        toID, fromID, state.booking.bookingId);
    var newBooking = BookingTo(state.booking, userTo);
    currentLockerCubit.loadData();
    emit(LockerDetailStateDefault(newBooking));
  }

  void shareViaWhatsapp(DBUser userTo, DBUser userFrom) async {
    if (state is LockerDetailStateShare) {
      launch("https://wa.me/${userTo.number}?text=Hello");
      shareSuccess(userTo, userFrom);
    }
  }

  void shareViaSMS(DBUser userTo, DBUser userFrom) async {
    if (state is LockerDetailStateShare) {
      sendSMS(message: "", recipients: [userTo.number]);
      shareSuccess(userTo, userFrom);
    }
  }

  void shareSuccess(DBUser userTo, DBUser userFrom) async {
    emit(LockerDetailStateLoading(state.booking));
    await currentLockersRepository.shareBooking(
        userTo.number, userFrom.uid, state.booking.bookingId);
    var newBooking = BookingTo(state.booking, userTo);
    currentLockerCubit.loadData();
    emit(LockerDetailStateDefault(newBooking));
  }
}
