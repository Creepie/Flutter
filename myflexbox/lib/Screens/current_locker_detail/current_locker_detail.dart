import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:myflexbox/cubits/auth/auth_cubit.dart';
import 'package:myflexbox/cubits/auth/auth_state.dart';
import 'package:myflexbox/cubits/locker_detail/locker_detail_cubit.dart';
import 'package:myflexbox/cubits/locker_detail/locker_detail_state.dart';
import 'package:myflexbox/repos/models/booking.dart';
import 'package:myflexbox/repos/models/user.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myflexbox/config/debounce.dart';

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
              BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                List<String> favoriteIds =
                    (state as AuthAuthenticated).user.favourites;
                if (!(booking is BookingFrom)) {
                  return Expanded(
                      child: IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () {
                            cubit.showShare(favoriteIds);
                          }));
                } else {
                  return Spacer();
                }
              }),
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

  CurrentLockerShareView({Key key, this.booking, this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: IntrinsicHeight(
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
            Container(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
              child: TextFormField(
                autocorrect: false,
                onChanged: (text) async {
                  cubit.filterShare(text);
                  //debouncer.run(() => cubit.filterShare(text));
                },
                decoration: InputDecoration(
                    labelText: "Nummer oder Namen eingeben",
                    hintText: "Nummer oder Namen eingeben",
                    labelStyle: TextStyle(color: Colors.grey),
                    focusColor: Colors.grey,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            BlocBuilder<LockerDetailCubit, LockerDetailState>(
                builder: (context, state) {
              List<DBUser> contactList =
                  (state as LockerDetailStateShare).contactsFiltered;
              var contactListLength =
                  contactList == null ? 0 : contactList.length;
              List<DBUser> favoritesList =
                  (state as LockerDetailStateShare).favoritesFiltered;
              var favoritesListLength =
                  favoritesList == null ? 0 : favoritesList.length;

              if (favoritesList != null &&
                  contactList != null &&
                  favoritesListLength == 0 &&
                  contactListLength == 0) {
                var filterText = (state as LockerDetailStateShare).filter;
                var validNumber = checkIfNumberValid(filterText);
                var text;
                if (validNumber) {
                  text = "Das Paket an " + filterText + " senden?";
                } else {
                  text =
                      "Um direkt an eine Nummer zu schicken, geben Sie bitte eine gültige Telefon-Nummer ein";
                }

                return BlocBuilder<AuthCubit, AuthState>(
                    builder: (authContext, authState) {
                  return Container(
                    height: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                        ),
                        Container(
                            child: Text(
                              "Es wurde kein Passender Kontakt oder Favorit gefunden.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey,
                                  letterSpacing: .7,
                                  height: 1.5),
                            ),
                            width: 250),
                        Container(
                          height: 10,
                        ),
                        FlatButton(
                            onPressed: () {
                              cubit.shareViaWhatsapp(
                                (state as LockerDetailStateShare).filter,
                                  (authState as AuthAuthenticated).user,
                              );
                            },
                            color: validNumber ? Colors.green : Colors.grey,
                            child: Text(
                              "Mit WhatsApp senden",
                              style: TextStyle(color: Colors.white),
                            )),
                        Container(
                          height: 5,
                        ),
                        FlatButton(
                            onPressed: () {
                              cubit.shareViaSMS(
                                (state as LockerDetailStateShare).filter,
                                (authState as AuthAuthenticated).user,
                              );
                            },
                            color: validNumber
                                ? Colors.lightBlueAccent
                                : Colors.grey,
                            child: Text(
                              "Mit SMS senden",
                              style: TextStyle(color: Colors.white),
                            )),
                        Container(
                          height: 10,
                        ),
                        Container(
                            child: Text(
                              text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey,
                                  letterSpacing: .7,
                                  height: 1.5),
                            ),
                            width: 250),
                      ],
                    ),
                  );
                });
              }

              return Container(
                  height: 400,
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        DBUser dbUser;
                        //First Separator
                        if (index == 0) {
                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 30,
                                color: Colors.grey.shade200,
                                child: Center(
                                  child: Text("Favoriten"),
                                ),
                              ),
                              favoritesList == null
                                  ? Container(
                                      height: 140,
                                      child: Center(
                                        child: SizedBox(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 4,
                                          ),
                                          height: 30.0,
                                          width: 30.0,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              favoritesList != null && favoritesListLength == 0
                                  ? Container(
                                      child: Center(
                                        child: Text(
                                          "Keine Favoriten gefunden",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      padding:
                                          EdgeInsets.only(top: 30, bottom: 30),
                                    )
                                  : Container(),
                            ],
                          ); // zero height: not visible
                        }
                        //Second Separator
                        if (index == favoritesListLength + 1) {
                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 30,
                                color: Colors.grey.shade200,
                                child: Center(
                                  child: Text("Kontakte"),
                                ),
                              ),
                              contactList == null
                                  ? Container(
                                      height: 140,
                                      child: Center(
                                        child: SizedBox(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 4,
                                          ),
                                          height: 30.0,
                                          width: 30.0,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              contactList != null && contactListLength == 0
                                  ? Container(
                                      child: Center(
                                        child: Text(
                                          "Keine Kontakte gefunden",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      padding:
                                          EdgeInsets.only(top: 30, bottom: 30),
                                    )
                                  : Container(),
                            ],
                          );
                        }
                        //User
                        if (index < favoritesListLength + 1) {
                          dbUser = favoritesList[index - 1];
                        } else {
                          dbUser =
                              contactList[index - (favoritesListLength + 2)];
                        }
                        return ListItem(dbUser, cubit);
                      },
                      separatorBuilder: (context, index) {
                        if (index == 0 ||
                            (index == favoritesListLength + 1) ||
                            index == favoritesListLength) {
                          return Container();
                        }
                        return Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey,
                        );
                      },
                      itemCount: favoritesListLength + contactListLength + 2));
            })
          ],
        ),
      ),
    );
  }

  bool checkIfNumberValid(String number) {
    var numberWithoutSpaces = number.replaceAll(" ", "");
    var numberWithoutPlus = numberWithoutSpaces.replaceAll("+", "");
    if (!numberWithoutPlus.startsWith("43")) {
      return false;
    }
    if (number.length <= 6) {
      return false;
    }
    return int.tryParse(numberWithoutPlus) != null;
  }
}

class ListItem extends StatelessWidget {
  final DBUser user;
  final LockerDetailCubit lockerDetailCubit;

  ListItem(this.user, this.lockerDetailCubit);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      return Slidable(
          actionPane: SlidableDrawerActionPane(),
          child: new Builder(builder: (context) {
            return Container(
              child: ListTile(
                contentPadding:
                    EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                title: Text(user.name),
                subtitle: Text(user.number),
                trailing: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => {
                          Slidable.of(context)
                              .open(actionType: SlideActionType.secondary)
                        }),
              ),
            );
          }),
          secondaryActions: user.uid == null
              ? <Widget>[
                  IconSlideAction(
                    caption: 'Whatsapp',
                    color: Colors.green,
                    icon: Icons.messenger_outline,
                    onTap: () => {
                      lockerDetailCubit.shareViaWhatsapp(
                          user.number, (state as AuthAuthenticated).user)
                    },
                  ),
                  IconSlideAction(
                    caption: 'SMS',
                    color: Colors.blue,
                    icon: Icons.sms_outlined,
                    onTap: () => {
                      lockerDetailCubit.shareViaSMS(
                          user.number, (state as AuthAuthenticated).user)
                    },
                  ),
                ]
              : <Widget>[
                  IconSlideAction(
                    caption: 'Bestätigen',
                    color: Colors.red,
                    icon: Icons.whatshot,
                    onTap: () => {
                      lockerDetailCubit.shareViaFlexBox(
                          user, (state as AuthAuthenticated).user)
                    },
                  ),
                ]);
    });
  }
}
/*

 */
