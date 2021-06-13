import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/repos/models/booking.dart';
import 'locker_detail_state.dart';
import 'package:myflexbox/repos/get_locker_booking_repo.dart';
import 'dart:io';


class LockerDetailCubit extends Cubit<LockerDetailState> {
  final GetLockerBooking currentLockersRepository;

  LockerDetailCubit(Booking booking, this.currentLockersRepository) : super(LockerDetailStateDefault(booking));

  void showQR() async {
    emit(LockerDetailStateLoading(state.booking));
    MemoryImage image = await currentLockersRepository.getQR(state.booking.compartmentId);
    emit(LockerDetailStateQR(state.booking, image));
  }

  void showShare() {
    emit(LockerDetailStateShare(state.booking));
  }

  void showDefault() {
    emit(LockerDetailStateDefault(state.booking));
  }

}