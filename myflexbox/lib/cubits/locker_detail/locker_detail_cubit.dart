import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/repos/models/booking.dart';
import 'locker_detail_state.dart';


class LockerDetailCubit extends Cubit<LockerDetailState> {
  final currentLockersRepository;

  LockerDetailCubit(Booking booking, this.currentLockersRepository, ) : super(LockerDetailStateDefault(booking));

}