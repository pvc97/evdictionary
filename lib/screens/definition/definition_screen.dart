import 'package:flutter/material.dart';
import 'package:ev_dictionary/utilities/word.dart';
import 'package:flutter_html/flutter_html.dart';

class DefinitionScreen extends StatelessWidget {
  final Word word;

  DefinitionScreen({@required this.word});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(word.word),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Html(
            data: word.html,
          ),
        ),
      ),
    );
  }
}
