import 'package:ev_dictionary/utilities/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:ev_dictionary/utilities/word.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ev_dictionary/utilities/constaints.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sqflite/sqflite.dart';
import 'components/custom_button.dart';
import 'components/shared_appbar.dart';

class DefinitionScreen extends StatefulWidget {
  final Word word;
  final Translate translateType;

  DefinitionScreen({@required this.word, this.translateType});

  @override
  _DefinitionScreenState createState() => _DefinitionScreenState();
}

class _DefinitionScreenState extends State<DefinitionScreen> {
  final FlutterTts flutterTts = FlutterTts();

  Future _speak() async {
    if (widget.translateType == Translate.av) {
      await flutterTts.setLanguage('en-US');
    } else if (widget.translateType == Translate.va) {
      await flutterTts.setLanguage('vi-VN');
    }

    await flutterTts.setSpeechRate(0.8);
    await flutterTts.speak(widget.word.word);
  }

  Icon getIconType() {
    IconData iconData;
    Color iconColor;

    if (widget.word.favorite != 0) {
      iconData = Icons.star_rounded;
    } else {
      iconData = Icons.star_border_rounded;
    }

    if (widget.translateType == Translate.av) {
      iconColor = kEnglishAppbarColor;
    } else {
      iconColor = kVietnameseAppbarColor;
    }

    return Icon(iconData, color: iconColor);
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
          title: widget.word.word,
          backgroundColor: widget.translateType == Translate.av
              ? kEnglishAppbarColor
              : kVietnameseAppbarColor,
          customButton: CustomButton(
            icon: getIconType(),
            onPressed: () async {
              Database db = await DatabaseHelper.instance.database;
              String tableName;
              int favoriteNumber;
              // favorite word in av mark is 1
              // favorite word in va mark is 2
              // if not favorite: default value is 0

              if (widget.translateType == Translate.av) {
                tableName = 'av';
                favoriteNumber = 1;
              } else {
                tableName = 'va';
                favoriteNumber = 2;
              }

              if (widget.word.favorite == 0) {
                // Set this word to favorite
                db.rawQuery(
                    'UPDATE $tableName SET favorite = $favoriteNumber WHERE id = ${widget.word.id}');
                widget.word.setfavorite = favoriteNumber;
              } else {
                // Set this word to normal, favorite = 0
                db.rawQuery(
                    'UPDATE $tableName SET favorite = 0 WHERE id = ${widget.word.id}');
                widget.word.setfavorite = 0;
              }
              setState(() {});
            },
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
    if (widget.word.html.length > 2000) {
      await Future.delayed(const Duration(milliseconds: 400));
    }

    return Html(
      data: widget.word.html,
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
