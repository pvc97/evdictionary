import 'package:flutter/material.dart';
import 'package:ev_dictionary/utilities/word.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ev_dictionary/utilities/constaints.dart';
import 'package:flutter_tts/flutter_tts.dart';

class DefinitionScreen extends StatelessWidget {
  final Word word;
  final FlutterTts flutterTts = FlutterTts();
  final Translate translateType;

  DefinitionScreen({@required this.word, this.translateType});

  Future _speak() async {
    print(translateType);
    if (translateType == Translate.av) {
      await flutterTts.setLanguage('en-US');
    } else if (translateType == Translate.va) {
      await flutterTts.setLanguage('vi-VN');
    }

    await flutterTts.setSpeechRate(0.8);
    await flutterTts.speak(word.word);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: translateType == Translate.av
            ? kEnglishAppbarColor
            : kVietnameseAppbarColor,
        toolbarHeight: size.height * 0.1,
        title: Text(
          word.word,
          style: TextStyle(
            fontSize: 30.0,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(
              right: 10.0,
            ),
            // Using RawMaterialButton because IconButton don't have background color
            child: RawMaterialButton(
              child: Icon(
                Icons.star_border,
                color: translateType == Translate.av
                    ? kEnglishAppbarColor
                    : kVietnameseAppbarColor,
              ),
              onPressed: () {},
              elevation: 0.0,
              constraints: BoxConstraints.tightFor(
                width: 40.0,
                height: 40.0,
              ),
              shape: CircleBorder(), // Button Tròn
              fillColor: Colors.white,
            ),
          ),
        ],
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: kBackgroundColor,
            ),
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Html(
                data: word.html,
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 10,
            child: RawMaterialButton(
              onPressed: () {
                _speak();
                print('??');
              },
              elevation: 1.0,
              fillColor: Colors.white,
              child: Icon(
                Icons.volume_up,
                size: 20.0,
              ),
              shape: CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
