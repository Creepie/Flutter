import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/cubits/locker_detail/locker_detail_cubit.dart';
import 'package:myflexbox/cubits/locker_detail/locker_detail_state.dart';
import 'package:myflexbox/repos/models/booking.dart';

class CurrentLockerDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LockerDetailCubit, LockerDetailState>(
      builder: (context, state) {
        LockerDetailCubit cubit = context.read<LockerDetailCubit>();
        if (state is LockerDetailStateDefault) {
          return CurrentLockerDefaultView(booking: state.booking, cubit: cubit);
        } else if (state is LockerDetailStateShare) {
          return CurrentLockerShareView(booking: state.booking, cubit: cubit);
        } else if (state is LockerDetailStateQR) {
          MemoryImage image = state.qr;
          return CurrentLockerQRView(
              booking: state.booking, cubit: cubit, qr: image);
        } else {
          return IntrinsicHeight(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(""),
                  ],
                ),
                Container(
                  height: 150,
                  child: Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                      ),
                      height: 30.0,
                      width: 30.0,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class CurrentLockerDefaultView extends StatelessWidget {
  final Booking booking;
  final LockerDetailCubit cubit;

  const CurrentLockerDefaultView({Key key, this.booking, this.cubit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Fertig")),
              ),
              Expanded(
                child: Center(
                  child: Text(booking.state == "COLLECTED"
                      ? "abgeholt"
                      : booking.state == "BOOKING_CREATED"
                          ? "gebucht"
                          : booking.state == "NOT_COLLECTED"
                              ? "eingelagert"
                              : "gecancelt"),
                ),
                flex: 2,
              ),
              !(booking is BookingFrom)
                  ? Expanded(
                      child: IconButton(
                          icon: Icon(Icons.screen_share),
                          onPressed: () {
                            cubit.showShare();
                          }),
                    )
                  : Spacer()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Von: "),
              booking is BookingFrom
                  ? Text((booking as BookingFrom).fromUser.name)
                  : Text("Mir")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("An: "),
              booking is BookingFrom
                  ? Text("Mich")
                  : booking is BookingTo
                      ? Text((booking as BookingTo).toUser.name)
                      : Text("---")
            ],
          ),
          FlatButton(
              onPressed: () {
                cubit.showQR();
              },
              child: Text("QR anzeigen"))
        ],
      ),
    );
  }
}

class CurrentLockerQRView extends StatelessWidget {
  final Booking booking;
  final LockerDetailCubit cubit;
  final MemoryImage qr;

  const CurrentLockerQRView({Key key, this.booking, this.cubit, this.qr})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Fertig")),
              ),
              Expanded(
                child: Center(
                  child: Text(booking.state == "COLLECTED"
                      ? "Bereits abgeholt"
                      : booking.state == "BOOKING_CREATED"
                          ? "Einlagern"
                          : booking.state == "NOT_COLLECTED"
                              ? "Abholen"
                              : "Gecancelt"),
                ),
                flex: 2,
              ),
              Expanded(
                child: FlatButton(
                    onPressed: () {
                      cubit.showDefault();
                    },
                    child: Text("Zurück")),
              ),
            ],
          ),
          Opacity(
            opacity: booking.state == "BOOKING_CREATED" ||
                    booking.state == "NOT_COLLECTED"
                ? 1
                : .3,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                image: new DecorationImage(
                  fit: BoxFit.cover,
                  image: qr,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CurrentLockerShareView extends StatelessWidget {
  final Booking booking;
  final LockerDetailCubit cubit;

  const CurrentLockerShareView({Key key, this.booking, this.cubit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Fertig")),
              ),
              Expanded(
                child: Center(
                  child: Text("Locker sharen"),
                ),
                flex: 2,
              ),
              Expanded(
                child: FlatButton(
                    onPressed: () {
                      cubit.showDefault();
                    },
                    child: Text("Zurück")),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
