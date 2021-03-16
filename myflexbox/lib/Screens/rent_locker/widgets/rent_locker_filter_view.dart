import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/cubits/rent_locker/rent_locker_cubit.dart';
import 'package:myflexbox/cubits/rent_locker/rent_locker_state.dart';

class RentLockerFilterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentLockerCubit, RentLockerState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Filter Screen'),
                getRadioButtons(),
                FlatButton(
                  child: Text("Show Map"),
                  onPressed: () {
                    final rentLockerCubit = context.read<RentLockerCubit>();
                    rentLockerCubit.showMapScreen();
                  },
                ),
              ],
            ),
          );
        },
    );
  }

  Widget getRadioButtons() {
    return BlocBuilder<RentLockerCubit, RentLockerState>(
      builder: (context, state) {
        return Column(
          children: <Widget>[
            ListTile(
              title: const Text('Small'),
              leading: Radio(
                value: BoxSize.small,
                groupValue: (state as FilterRentLockerState).boxSize,
                onChanged: (BoxSize value) {
                  final rentLockerCubit = context.read<RentLockerCubit>();
                  rentLockerCubit.changeBoxSize(BoxSize.small);
                },
              ),
            ),
            ListTile(
              title: const Text('Medium'),
              leading: Radio(
                value: BoxSize.medium,
                groupValue: (state as FilterRentLockerState).boxSize,
                onChanged: (BoxSize value) {
                  final rentLockerCubit = context.read<RentLockerCubit>();
                  rentLockerCubit.changeBoxSize(BoxSize.medium);
                },
              ),
            ),
            ListTile(
              title: const Text('Big'),
              leading: Radio(
                value: BoxSize.big,
                groupValue: (state as FilterRentLockerState).boxSize,
                onChanged: (BoxSize value) {
                  final rentLockerCubit = context.read<RentLockerCubit>();
                  rentLockerCubit.changeBoxSize(BoxSize.big);
                },
              ),
            ),
          ],
        );
      }
    );
  }
}