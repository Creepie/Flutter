import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  LockerDetailCubit(Booking booking, this.currentLockersRepository)
      : super(LockerDetailStateDefault(booking));

  void showQR() async {
    emit(LockerDetailStateLoading(state.booking));
    MemoryImage image =
        await currentLockersRepository.getQR(state.booking.compartmentId);
    emit(LockerDetailStateQR(state.booking, image));
  }

  void showShare(List<String> favoriteIds) {
    emit(LockerDetailStateShare(state.booking, null, null, null, null, ""));
    getFavorites(favoriteIds);
    getContacts();
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

  void getFavorites(List<String> favoriteIds) async {
    List<DBUser> favorites = [];

    //await Future.delayed(Duration(seconds: 20));

    for (final favoriteID in favoriteIds) {
      favorites.add(await userRepository.getUserFromDB(favoriteID));
    }

    if (state is LockerDetailStateShare) {
      var shareState = state as LockerDetailStateShare;
      emit(LockerDetailStateShare(
          shareState.booking,
          shareState.contacts,
          shareState.contactsFiltered,
          favorites,
          favorites,
          shareState.filter));
    }
  }

  //TODO Filter favorites
  void getContacts() async {
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    List<String> fav = [];
    List<DBUser> dbList = [];

    for (int i = 0; i < _contacts.length; i++) {
      var contactNumbers = _contacts[i].phones.toList();
      for (int j = 0; j < _contacts[i].phones.length; j++) {
        dbList.add(DBUser("", _contacts[i].displayName,
            contactNumbers[j].value.replaceAll(" ", ""), null, fav));
      }
    }

    if (state is LockerDetailStateShare) {
      var shareState = state as LockerDetailStateShare;
      emit(LockerDetailStateShare(
          shareState.booking,
          dbList,
          dbList,
          shareState.favorites,
          shareState.favoritesFiltered,
          shareState.filter));
    }
  }

  void showDefault() {
    emit(LockerDetailStateDefault(state.booking));
  }

  void shareViaWhatsapp(String numberTo, DBUser userFrom) async {
    if (state is LockerDetailStateShare) {
      await launch(
              "https://wa.me/$numberTo?text=Hello");
    }
  }

  void shareViaSMS(String numberTo, DBUser userFrom) async {
    if (state is LockerDetailStateShare) {
      await sendSMS(message: "", recipients: [numberTo])
          .catchError((onError) {
        print(onError);
      });
    }
  }

  void shareViaFlexBox(DBUser userTo, DBUser userFrom) async {
    String toID = userTo.uid == null ? userTo.number : userTo.uid;
    String fromID = userFrom.uid == null ? userFrom.number : userFrom.uid;

    emit(LockerDetailStateLoading(state.booking));
    await currentLockersRepository.shareBooking(
        toID, fromID, state.booking.bookingId);
    var newBooking = BookingTo(state.booking, userTo);
    emit(LockerDetailStateDefault(newBooking));
  }
}
