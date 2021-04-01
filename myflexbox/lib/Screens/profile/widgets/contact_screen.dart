import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:myflexbox/config/app_router.dart';
import 'package:myflexbox/config/size_config.dart';
import 'package:myflexbox/config/constants.dart';


class ContactScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ///init the SizeConfig class for height and weight calc methods
    SizeConfig().init(context);

    ///A Scaffold Widget provides a framework which implements the basic material
    /// design visual layout structure of the flutter app.
    /// It provides APIs for showing drawers, snack bars and bottom sheets.
    /// In a Scaffold you can add for example a button navigation bar
    return Scaffold(
      ///Body() is a Widget class which can be found at screens/splash/components
      body: Contacts(),
    );

  }
}


class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}


class _ContactsState extends State<Contacts> {



  /// List for all contacts
  List<Contact> contacts = [];
  /// list for sontacts after searcing
  List<Contact> contactsFiltered = [];
  /// controller for searching
  TextEditingController searchController = new TextEditingController();

  /// List for favorites
  List<Contact> _savedContacts = [];

  /// import all the contacts
  @override
  void initState() {
    getAllContacts();

    /// look if controller has changed or text inside the search input
    /// has changed -> you nedd a listener
    /// calls function everytime something changes in the searchcontroller text
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
    // save contacts on phone in a list
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();

    /// sort the favorites and put them at the front
    var test = _savedContacts;
    test.sort((a, b) => a.displayName.compareTo(b.displayName));
    test += _contacts;

    /// rebuild the List after flutter has the contacts
    /// populates the list
    setState(() {
      /// remove duplicates
      contacts = test.toSet().toList();
      //contacts = _contacts;
    });
  }

  /// filter the contact list after letters and numbers
  filterContacts(){
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);

    if(searchController.text.isNotEmpty){
      /// see which contact matches with the input in searchbar
      /// removes the ones who dont match in the list
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumer(searchTerm);

        String contactName = contact.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);

        // found name
        if(nameMatches == true){
          return true;
        }

        if(searchTermFlatten.isEmpty){
          return false;
        }

        // found by phone number
        var phone = contact.phones.firstWhere((phn) {
          String phnFlattened = flattenPhoneNumer(phn.value);
          return phnFlattened.contains(searchTermFlatten);
        }, orElse: () => null);

        return phone != null;
      });

      /// forces UI to rebuild and display filtered list
      setState(() {
        contactsFiltered = _contacts;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;

   // const kPrimaryColor = Color(0xFFD20A10);


    return Scaffold(
      appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
         iconTheme: IconThemeData(
           color: Colors.black54
         ),
          title: Text(
            "Kontakte",
            style: TextStyle(color: Colors.black54),
          ),
        ),


      /// add Button
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          try {
            Contact contact = await ContactsService.openContactForm();

            // firebase durchsuchen nach telnr.
            // falls gefunden User in firebase kontakte sichern
            // zu favoriten

            if(contact != null){
              getAllContacts();
            }

          } on FormOperationException catch (e) {
            switch(e.errorCode) {
              case FormOperationErrorCode.FORM_OPERATION_CANCELED:
              case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
              case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
                print(e.toString());
            }
          }
        },
      ),
      /// widget that combines common paiinting, positioning and sizing widgets
      body: Container(
        padding: EdgeInsets.all(20),
        /// displays its children in a vertical array
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
            /// expands a child of a row, column or flex so that the child
            /// fills the available space
            Expanded(
              /// Populates the List
                child:  ListView.builder(
                    shrinkWrap: true,
                    // check if user is searching or not
                    itemCount: isSearching == true ? contactsFiltered.length : contacts.length,
                    itemBuilder: (context, index){
                      Contact contact = isSearching == true ? contactsFiltered[index] : contacts[index];

                      /// check if the user already saved the contact to favorites
                      bool alreadySaved = _savedContacts.contains(contact);

                      /// displays the user name and the phone number
                      return ListTile(
                          title: Text(contact.displayName),
                          subtitle: Text(
                            // when user has more phone numbers takes the first one
                              contact.phones.elementAt(0).value
                          ),
                          /// if the user has an image saved for the contact show the image
                          /// else show the initials of the name from the contact
                          leading: (contact.avatar != null && contact.avatar.length > 0) ?
                          CircleAvatar(
                            backgroundImage: MemoryImage(contact.avatar),
                          ) :
                          CircleAvatar(
                            child: Text(contact.initials(),
                            style: TextStyle(
                              color: Colors.white,
                            )),
                            backgroundColor:  Theme.of(context).primaryColor,),

                          // firebase durchsuchen ob nummer in der app registriert ist
                          // ansonsten person icon -> einladung schicken

                          trailing: new IconButton(icon: Icon(alreadySaved ? Icons.favorite:
                          Icons.favorite_border, color: alreadySaved ? Colors.red: null,),
                              onPressed: () {
                                setState(() {
                                  if(alreadySaved){
                                    // firebase

                                    _savedContacts.remove(contact);
                                    contacts.add(contact);

                                    getAllContacts();
                                  } else {
                                    _savedContacts.add(contact);
                                    contacts.remove(contact);

                                    getAllContacts();
                                  }
                                });
                              })
                      );
                    })
            )
          ],
        ),
      ),
    );
  }
}