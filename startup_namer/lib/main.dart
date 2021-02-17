import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

///<<< StatelessWidget >>>
///A widget that does not require mutable state.
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
    );
  }
}

///<<< StatefulWidget >>>
/// State is information that
/// (1) can be read synchronously when the widget is built and
/// (2) might change during the lifetime of the widget
class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = TextStyle(fontSize: 18.0);

  ///the build method describes how to display the widget and the widgets the widget
  @override
  Widget build(BuildContext context) {
    ///<<< Scaffold >>>
    /// Widget with a AppBar (with for a example a title in it)
    /// and a body which can hold a widget subtree (in a widget can be more widgets)
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
    );
  }

  ///<<< ListView >>>
  ///this method creates and returns a ListView
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {

          //if index is uneven
          //returns a one-pixel-high divider widget before each row in the ListView.
          if (i.isOdd) return Divider();

          //dart syntax of integer division (no num type)
          final index = i ~/ 2;

          //if user scrolls down to till the current end of the list
          //if yes add 10 new words into the _suggestions list
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          //start the _buildRow function and return a new Row for the ListView
          return _buildRow(_suggestions[index]);
        });
  }

  ///<<< ListTile >>>
  ///this method creates and return a Row for the ListView with the given wordPair
  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }
}
