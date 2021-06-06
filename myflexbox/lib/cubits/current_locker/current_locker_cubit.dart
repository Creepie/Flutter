import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/repos/get_locker_booking_repo.dart';
import 'package:myflexbox/repos/models/booking.dart';
import 'current_locker_state.dart';

class CurrentLockerCubit extends Cubit<CurrentLockerState> {
  GetLockerBooking repo = new GetLockerBooking();

  CurrentLockerCubit()
      : super(new CurrentLockerLoading());

  void loadData() async{
    emit(new CurrentLockerLoading());
    List<Booking> bookingList = await repo.getBookings("");
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

