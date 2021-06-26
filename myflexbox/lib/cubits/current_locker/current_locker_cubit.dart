import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/repos/get_locker_booking_repo.dart';
import 'package:myflexbox/repos/models/booking.dart';
import 'current_locker_state.dart';

class CurrentLockerCubit extends Cubit<CurrentLockerState> {
  GetLockerBooking repo = new GetLockerBooking();
  var myUserId = FirebaseAuth.instance.currentUser.uid;
  //todo get userid from firebase and put it into getBookings if everything is ready

  CurrentLockerCubit()
      : super(new CurrentLockerLoading());

  Future<void> loadData() async{
    emit(new CurrentLockerLoading());
    List<Booking> bookingList = await repo.getBookings("z1k9qFupQpdcHCwnWWbq9Nrl6im1");
    if(bookingList.isNotEmpty){
      emit(new CurrentLockerList(bookingList: bookingList));
    } else {
      emit(new CurrentLockerEmpty());
    }
  }

  //Needed for error-free background actualisation
  Future<void> loadDataBackground() async{
    List<Booking> bookingList = await repo.getBookings("z1k9qFupQpdcHCwnWWbq9Nrl6im1");
    if(bookingList.isNotEmpty){
      emit(new CurrentLockerList(bookingList: bookingList));
    } else {
      emit(new CurrentLockerEmpty());
    }
  }

  void filterData(){
    if(state is CurrentLockerList){
      List<Booking> bookingList = (state as CurrentLockerList).bookingList;
    }
  }

}

