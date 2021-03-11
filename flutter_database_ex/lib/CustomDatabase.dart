import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class CustomData extends StatefulWidget {
  CustomData({this.app});

  final FirebaseApp app;

  @override
  _CustomDataState createState() => _CustomDataState();
}

class _CustomDataState extends State<CustomData> {
  final referenceDatabase = FirebaseDatabase.instance;

  final user = 'User';
  final editTextController = TextEditingController();

  DatabaseReference userDb;

  @override
  void initState() {
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    userDb = database.reference().child('Users');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ref = referenceDatabase.reference();
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
                    Container(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        "Usertable",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius:  BorderRadius.circular(32),
                      ),
                      margin: const EdgeInsets.all(8.0),
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
                    TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            primary: Colors.white),
                        onPressed: () {
                          Person person = new Person(editTextController.text, true);
                          ref.child('Users')
                              .push()
                              .child(user)
                              .set(person.toJson())
                              .asStream();
                          editTextController.clear();
                        },
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

  Widget firebaseList(){
    return new FirebaseAnimatedList(
        shrinkWrap: true,
        query: userDb,
        itemBuilder: (BuildContext context,
            DataSnapshot snapshot,
            Animation<double> animation,
            int index) {
          Person person = Person.fromJson(snapshot.value['User']);
          return new ListTile(
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () =>
                    userDb.child(snapshot.key).remove(),
              ),
              title: new Text("Name: ${person.name}"),
              subtitle: new Text("isGay: ${person.isGay}")
          );
        });
  }
}


class Person{
  final String name;
  final bool isGay;

  Person(this.name, this.isGay);
  Person.json({this.name, this.isGay});

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'isGay': isGay,
      };

  factory Person.fromJson(Map<dynamic, dynamic> json) {
    return Person.json(
      name: json['name'] as String,
      isGay: json['isGay'] as bool,
    );
  }
}
