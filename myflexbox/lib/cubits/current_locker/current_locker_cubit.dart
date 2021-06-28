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
      : super(new CurrentLockerLoading({
    FilterStates.BOOKING_CREATED : true,
    FilterStates.COLLECTED : true,
    FilterStates.NOT_COLLECTED : true,
    FilterStates.CANCELLED : true,
  }));

  Future<void> loadData() async{
    emit(new CurrentLockerLoading(state.filter));
    loadDataBackground();
  }

  //Needed for error-free background actualisation
  Future<void> loadDataBackground() async{
    List<Booking> bookingList = await repo.getBookings("z1k9qFupQpdcHCwnWWbq9Nrl6im1");
      if(bookingList.isNotEmpty){
        //change to filterData if ready
        var filteredList = filterData(state.filter, bookingList);
        emit(new CurrentLockerList(bookingList: bookingList, bookingListFiltered: filteredList,filter: state.filter));
      } else {
        emit(new CurrentLockerEmpty(state.filter));
      }
  }

  Future<void> changeFilter(FilterStates filterSate) async {
    if(state is CurrentLockerList){
      Map<FilterStates,bool> updatedMap = new Map.from(state.filter);
      updatedMap[filterSate] = !updatedMap[filterSate];
      //change to filterData if ready
      var filteredList = filterData(updatedMap, (state as CurrentLockerList).bookingList);
      emit(new CurrentLockerList(bookingList: (state as CurrentLockerList).bookingList, bookingListFiltered: filteredList, filter: updatedMap));
    }
  }

  List<Booking> filterData(Map<FilterStates, bool> filter, List<Booking> bookingList){
      //create new list and return theme after the loop
      List<Booking> filteredList = [];

      for(int i = 0; i < bookingList.length; i++){
        if(bookingList[i].state == FilterStates.BOOKING_CREATED.toShortString() && filter[FilterStates.BOOKING_CREATED] == true){
            filteredList.add(bookingList[i]);
        } else if(bookingList[i].state == FilterStates.COLLECTED.toShortString() && filter[FilterStates.COLLECTED] == true){
          filteredList.add(bookingList[i]);
        }  else if(bookingList[i].state == FilterStates.NOT_COLLECTED.toShortString() && filter[FilterStates.NOT_COLLECTED] == true){
          filteredList.add(bookingList[i]);
        }  else if(bookingList[i].state == FilterStates.CANCELLED.toShortString() && filter[FilterStates.CANCELLED] == true){
          filteredList.add(bookingList[i]);
        }
      }//end loop
      return filteredList;

  }
}

