import 'package:flutter/material.dart';

class DefinitionScreen extends StatelessWidget {
  final String word;

  DefinitionScreen({@required this.word});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(word),
        centerTitle: true,
      ),
    );
  }
}
