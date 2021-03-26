import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/cubits/rent_locker/rent_locker_cubit.dart';
import 'package:myflexbox/cubits/rent_locker/rent_locker_state.dart';

class RentLockerMapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return BlocBuilder<RentLockerCubit, RentLockerState>(
        builder: (context, state) {
          return Center(
            child: Text("MapView"),
          );
        }
      );
  }
}