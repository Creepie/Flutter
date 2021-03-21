import 'dart:io';


import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

import 'package:share/share.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  ///this controller is to get the input number for direct whatsapp share
  final controller = TextEditingController();
  String text = '';
  String subject = '';
  ///in the index path are all picture paths saved for sharing
  List<String> imagePaths = [];
  ///add a ImagePicker
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    text = 'check out my website https://youtube.com';
    subject = "Look what I made!";

    ///atm its not working to share the test.png in the assets folder
    //imagePaths.add("sharing/assets/images/test.png");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                ///add the controller to the text field for later access of the text
                controller: controller,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.phone),
                    hintText: 'Enter a valid number with +43'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              ///this button opens the general share sheet and shares a text
              child: TextButton(
               onPressed: () => _onShareWithEmptyOrigin(context),
               child: Text("ShareSheet"),
              )
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              ///this button opens the camera > after that you can share this pic via ShareSheet
              child: TextButton(
                child: Text("Share from Camera"),
                onPressed: () async {
                  final result = await picker.getImage(source: ImageSource.camera);
                  if (result != null) {
                    imagePaths.add(result.path);
                    _onShare(context);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              ///this button should share the test.png file from the assets folder > not possible atm
              child: TextButton(
                child: Text("Share image from app"),
                onPressed: () => _onShare(context),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 12.0)),
            ///here you can add into you imagePaths pics from your gallery
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add image"),
              onTap: () async {
                final pickedFile = await picker.getImage(source: ImageSource.gallery,);
                if (pickedFile != null) {
                    imagePaths.add(pickedFile.path);
                }
              },
            ),
            const Padding(padding: EdgeInsets.only(top: 12.0)),
            Builder(
              builder: (BuildContext context) {
                ///this Button shares all Images in the imagePaths and open the shareSheet
                return ElevatedButton(
                  child: const Text('Share pictures'),
                  onPressed: text.isEmpty && imagePaths.isEmpty ? null : () => _onShare(context),
                );
              },
            ),
          ],
        ),
      ),
      ///this Button opens Whatsapp with the text input number directly and shares a Hello as text
      ///if input number is empty only Whatsapp gets open and you can chose the person
      floatingActionButton: FloatingActionButton(
        onPressed: () async =>
            await launch("https://wa.me/${controller.text}?text=Hello"),
        child: Icon(Icons.share),
        tooltip: 'Increment',
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  ///this method opens the Share Sheet
  _onShare(BuildContext context) async {

    final RenderBox box = context.findRenderObject() as RenderBox;

    if (imagePaths.isNotEmpty) {
      await Share.shareFiles(imagePaths,
          text: text,
          subject: subject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(text,
          subject: subject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  ///this method opens the share Sheet but only with text to share
  _onShareWithEmptyOrigin(BuildContext context) async {
    await Share.share("text");
  }

}

