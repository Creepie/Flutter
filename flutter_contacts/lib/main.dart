import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

/// Tutorial
///https://www.youtube.com/watch?v=NBIF-Wt_ZFQ


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Contacts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Contacts'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// List for all contacts
  List<Contact> contacts = [];
  /// list for sontacts after searcing
  List<Contact> contactsFiltered = [];
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getAllContacts();
    searchController.addListener(() {
      filterContacts();
    });
  }

  /// remove all special characters, except '+' at the begonning of phone number
  String flattenPhoneNumer(String phoneStr){
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  /// get all contacts that are on the phone
  getAllContacts() async {
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();

    /// rebuild the List after flutter has the contacts, populates the list
    setState(() {
      contacts = _contacts;
    });
  }

/// filter the contact list after letters and numbers
  filterContacts(){
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if(searchController.text.isNotEmpty){
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumer(searchTerm);
        String contactName = contact.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if(nameMatches == true){
          return true;
        }
        if(searchTermFlatten.isEmpty){
          return false;
        }
        
        var phone = contact.phones.firstWhere((phn) {
         String phnFlattened = flattenPhoneNumer(phn.value);
          return phnFlattened.contains(searchTermFlatten);
        }, orElse: () => null);

        return phone != null;
      });

      setState(() {
        contactsFiltered = _contacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
          Container(
            /// search bar for filtering the contacts
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: new OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Theme.of(context).primaryColor
                      )
                    ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  )
              ),
            ),
          ),
           Expanded(
               /// Populates the List
               child:  ListView.builder(
                   shrinkWrap: true,
                   itemCount: isSearching == true ? contactsFiltered.length : contacts.length,
                   itemBuilder: (context, index){
                     Contact contact = isSearching == true ? contactsFiltered[index] : contacts[index];
                     /// displays the user name and the phone number
                     return ListTile(
                         title: Text(contact.displayName),
                         subtitle: Text(
                             contact.phones.elementAt(0).value
                         ),
                         /// if the user has an image saved for the contact show the image
                         /// else show the initials of the name from the contact
                         leading: (contact.avatar != null && contact.avatar.length > 0) ?
                         CircleAvatar(
                           backgroundImage: MemoryImage(contact.avatar),
                         ) :
                         CircleAvatar(child: Text(contact.initials()),)
                     );
                   })
           )
          ],
        ),
      ),
    );
  }
}