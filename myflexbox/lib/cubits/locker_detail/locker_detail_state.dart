import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:myflexbox/repos/models/booking.dart';
import 'package:myflexbox/repos/models/user.dart';

abstract class LockerDetailState extends Equatable {
  final Booking booking;

  LockerDetailState(this.booking);

  //sets the value on which two states are compared. The UI is only rebuild, if
  //two stated are different.
  @override
  List<Object> get props => [booking];
}

class LockerDetailStateDefault extends LockerDetailState {
  LockerDetailStateDefault(Booking booking) : super(booking);
}

class LockerDetailStateShare extends LockerDetailState {
  final List<DBUser> contacts;
  final List<DBUser> contactsFiltered;
  final List<DBUser> favorites;
  final List<DBUser> favoritesFiltered;
  final String filter;

  LockerDetailStateShare(Booking booking, this.contacts, this.contactsFiltered, this.favorites, this.favoritesFiltered, this.filter) : super(booking);

  @override
  List<Object> get props => [booking, contacts, favorites, favoritesFiltered, contactsFiltered, filter];
}

class LockerDetailStateQR extends LockerDetailState {
  final MemoryImage qr;
  LockerDetailStateQR(Booking booking, this.qr) : super(booking);
}


class LockerDetailStateLoading extends LockerDetailState {
  LockerDetailStateLoading(Booking booking) : super(booking);
}