import 'package:flutter/material.dart';
import 'package:ev_dictionary/utilities/word.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ev_dictionary/utilities/constaints.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'components/shared_appbar.dart';

class DefinitionScreen extends StatelessWidget {
  final Word word;
  final FlutterTts flutterTts = FlutterTts();
  final Translate translateType;

  DefinitionScreen({@required this.word, this.translateType});

  Future _speak() async {
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.1),
        child: SharedAppBar(
          size: size,
          title: word.word,
          backgroundColor: translateType == Translate.av
              ? kEnglishAppbarColor
              : kVietnameseAppbarColor,
          icon: Icon(
            Icons.star_border_rounded,
            color: translateType == Translate.av
                ? kEnglishAppbarColor
                : kVietnameseAppbarColor,
          ),
          onPressed: () {},
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: kBackgroundColor,
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            margin: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              // Because Html Widget causes lagging when naviagate from
              // search screen with long html input
              // So I used FutureBuilder and _buildHtml with some delay to make
              // animation smoother
              child: FutureBuilder(
                future: _buildHtml(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data;
                  }

                  return Container(
                    height: size.height * 0.8,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 25.0,
            right: 10.0,
            child: RawMaterialButton(
              onPressed: () {
                _speak();
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

  Future<Widget> _buildHtml() async {
    if (word.html.length > 2000) {
      await Future.delayed(const Duration(milliseconds: 400));
    }

    return Html(
      data: word.html,
      style: {
        'h1': Style(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          margin: EdgeInsets.zero,
        ),
        'h3': Style(
          color: Colors.red,
        ),
        'h2': Style(
          color: Colors.blue[800],
        ),
      },
    );
  }
}
