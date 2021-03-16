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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Map-Screen"),
                Text((state as MapRentLockerState).boxSize.toString()),
                FlatButton(
                  child: Text("back"),
                  onPressed: () {
                    final rentLockerCubit = context.read<RentLockerCubit>();
                    rentLockerCubit.showFilterScreen();
                  },
                )
              ],
            ),
          );
        },
      );
  }
}