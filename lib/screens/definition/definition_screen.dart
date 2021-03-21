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
  bool isFavorite = false;

  void _getFavoriteType() async {
    Database db = await DatabaseHelper.instance.database;
    String tableName;
    if (widget.translateType == Translate.av) {
      tableName = 'av';
    } else {
      tableName = 'va';
    }

    List<Map> result = await db.rawQuery('''SELECT favorite.id FROM favorite 
        WHERE favorite.id = ${widget.word.id} 
        AND favorite.tb = '$tableName' ''');

    if (result.isNotEmpty) {
      isFavorite = true;
    } else {
      isFavorite = false;
    }
    setState(() {});
  }

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

    if (isFavorite) {
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
  void initState() {
    super.initState();
    _getFavoriteType();
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

              if (widget.translateType == Translate.av) {
                tableName = 'av';
              } else {
                tableName = 'va';
              }

              if (!isFavorite) {
                db.rawQuery(
                    '''INSERT INTO favorite (id, word, tb) VALUES (${widget.word.id}, '${widget.word.word}', '$tableName')''');
              } else {
                db.rawQuery(
                    '''DELETE FROM favorite WHERE id = ${widget.word.id} AND tb = '$tableName' ''');
              }

              setState(() {
                if (isFavorite == false) {
                  isFavorite = true;
                } else {
                  isFavorite = false;
                }
              });
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: kBackgroundCardColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            margin: const EdgeInsets.all(20),
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
            top: 25,
            right: 10,
            child: RawMaterialButton(
              onPressed: () {
                _speak();
              },
              elevation: 1,
              fillColor: Colors.white,
              child: const Icon(
                Icons.volume_up,
                size: 20,
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
    } else if (widget.word.html.length > 1200) {
      await Future.delayed(const Duration(milliseconds: 300));
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
