import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
  final controller = TextEditingController();
  String text = '';
  String subject = '';
  List<String> imagePaths = [];

  @override
  Widget build(BuildContext context) {
    text = 'check out my website https://youtube.com';
    subject = "Look what I made!";
    //imagePaths.add("assets/images/test.png");

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
              child: TextButton(
               onPressed: () => _onShareWithEmptyOrigin(context),
               child: Text("ShareSheet"),
              )
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                child: Text("Share from Pictures"),
                onPressed: () async {
                  FilePickerResult result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    print(result.files.single.path);
                    Share.shareFiles(["${result.files.single.path}"], text: "Images");
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                child: Text("Share image from app"),
                onPressed: () => _onShare(context),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async =>
            await launch("https://wa.me/${controller.text}?text=Hello"),
        child: Icon(Icons.share),
        tooltip: 'Increment',
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _onShare(BuildContext context) async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The ElevatedButton's RenderObject
    // has its position and size after it's built.
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
  
  _onShareWithEmptyOrigin(BuildContext context) async {
    await Share.share("text");
  }

}

