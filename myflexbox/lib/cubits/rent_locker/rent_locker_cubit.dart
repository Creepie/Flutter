import 'package:bloc/bloc.dart';
import 'package:myflexbox/cubits/rent_locker/rent_locker_state.dart';
import 'package:myflexbox/repos/rent_locker_repository.dart';


class RentLockerCubit extends Cubit<RentLockerState> {
  final RentLockerRepository _rentLockerRepository;

  RentLockerCubit(this._rentLockerRepository) : super(FilterRentLockerState(boxSize: BoxSize.medium));

  Future<void> showMapScreen() async {
    if(state is FilterRentLockerState) {
      emit(MapRentLockerState((state as FilterRentLockerState).boxSize));
    }
  }

  void changeBoxSize(BoxSize chosenBoxSize) {
    if(state is FilterRentLockerState) {
      emit(FilterRentLockerState(boxSize: chosenBoxSize));
    }
  }

  void showFilterScreen() {
    if(state is MapRentLockerState) {
      emit(FilterRentLockerState(boxSize: (state as MapRentLockerState).boxSize));
    }
  }

  Future<void> fetchResults() async {
  }


}