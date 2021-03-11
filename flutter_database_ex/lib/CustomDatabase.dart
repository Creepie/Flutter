import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class CustomData extends StatefulWidget {
  CustomData({this.app});

  ///add Firebase
  final FirebaseApp app;

  @override
  _CustomDataState createState() => _CustomDataState();
}

class _CustomDataState extends State<CustomData> {
  ///add a Controller to can access the input text of the textField
  final editTextController = TextEditingController();
  ///add a global userDb variable
  DatabaseReference userDb;

  @override
  void initState() {
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    userDb = database.reference().child('Users');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PersonList'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                color: Colors.grey,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    ///add a Header Text Widget with a padding
                    Container(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        "Usertable",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ///add a input TextField Widget where the user can type in a name
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius:  BorderRadius.circular(32),
                      ),
                      child: TextField(
                        controller: editTextController,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: 17),
                          hintText: 'Enter your name',
                          suffixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(20),
                        ),
                      ),
                    ),
                    ///Add a Button where the user can push up a Person object to Firebase db
                    TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            primary: Colors.white),
                        onPressed: () {
                          ///create a Person
                          Person person = new Person(editTextController.text, true);
                          ///push it to Firebase db
                          userDb.push()
                              .child('User')
                              .set(person.toJson());
                          ///clear the input text field
                          editTextController.clear();
                        },
                        ///give the button an Text
                        child: Text('add User')),
                    Flexible(
                        child: firebaseList()
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///function which returns a FirebaseAnimatedList
  Widget firebaseList(){
    return new FirebaseAnimatedList(
      ///If the scroll view does not shrink wrap, then the scroll view will expand
      ///to the maximum allowed size in the scrollDirection. If the scroll view
      /// has unbounded constraints in the scrollDirection, then shrinkWrap must be true.
        shrinkWrap: true,
        ///add the firebase query
        query: userDb,
        ///Called, as needed, to build list item widgets.
        ///List items are only built when they're scrolled into view.
        itemBuilder: (BuildContext context,
            DataSnapshot snapshot,
            Animation<double> animation,
            int index) {
          ///convert the db result to an person object
          Person person = Person.fromJson(snapshot.value['User']);
          ///A single fixed-height row that typically contains some text as well as a leading or trailing icon.
          return new ListTile(
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () =>
                ///if pressed delete this item in the app and on db
                    userDb.child(snapshot.key).remove(),
              ),
              title: new Text("Name: ${person.name}"),
              subtitle: new Text("isGay: ${person.isGay}")
          );
        });
  }
}

///Person object
class Person{
  final String name;
  final bool isGay;

  ///normal constructor
  Person(this.name, this.isGay);
  ///constructor for parsing from a json
  ///is used in factory below
  Person.json({this.name, this.isGay});

  ///from object to json
  ///is used to push the data up to the db
  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'isGay': isGay,
      };

  ///from json to object
  ///is used to parse the data from json to object
  factory Person.fromJson(Map<dynamic, dynamic> json) {
    return Person.json(
      name: json['name'] as String,
      isGay: json['isGay'] as bool,
    );
  }
}
