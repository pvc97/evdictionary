import 'package:ev_dictionary/screens/definition/components/custom_button.dart';
import 'package:ev_dictionary/screens/definition/definition_screen.dart';
import 'package:ev_dictionary/utilities/constaints.dart';
import 'package:ev_dictionary/utilities/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ev_dictionary/screens/history/components/history.dart';
import 'package:ev_dictionary/utilities/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ev_dictionary/screens/definition/components/shared_appbar.dart';
import 'package:ev_dictionary/screens/history/components/word_card.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<History> items = [];

  Future<List> _getListHistories() async {
    Database db = await DatabaseHelper.instance.database;

    // db.rawQuery('DELETE FROM history');
    List<Map> result =
        await db.rawQuery('SELECT * FROM history ORDER BY position DESC');

    List<History> histories = List.generate(
      result.length,
      (i) => History(
        position: result[i]['position'],
        id: result[i]['id'],
        word: result[i]['word'],
        table: result[i]['tb'],
      ),
    );

    return histories;
  }

  void _loadHistory() async {
    items = await _getListHistories();
    setState(() {});
  }

  void _deleteHistory() async {
    Database db = await DatabaseHelper.instance.database;
    db.rawQuery('DELETE FROM history');

    setState(() {
      items.clear();
    });
  }

  Future _onPressedWordCard(List items, int index) async {
    Database db = await DatabaseHelper.instance.database;

    String tableName;
    Translate translateType;
    if (items[index].table == 'av') {
      tableName = 'av';
      translateType = Translate.av;
    } else {
      tableName = 'va';
      translateType = Translate.va;
    }

    List<Map> result = await db.rawQuery(
        'SELECT * FROM $tableName WHERE $tableName.id = ${items[index].id}');

    List<Word> word = List.generate(
      result.length,
      (i) => Word(
        id: result[i]['id'],
        word: result[i]['word'],
        html: result[i]['html'],
        description: result[i]['description'],
        pronounce: result[i]['pronounce'],
        favorite: result[i]['favorite'],
      ),
    );

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => DefinitionScreen(
          word: word.first,
          translateType: translateType,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar can phai de trong PreferredSize
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.1),
        child: SharedAppBar(
          size: size,
          title: 'History',
          backgroundColor: kEnglishAppbarColor,
          customButton: CustomButton(
            icon: Icon(
              Icons.cleaning_services_rounded,
              color: Colors.blue,
            ),
            onPressed: _deleteHistory,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        // ListView not in Column don't have to wrap by Expaned
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return WordCard(
                items: items,
                index: index,
                flagDir: items[index].table == 'av'
                    ? kEnglishFlagDir
                    : kVietNamFlagDir,
                // Because onPressedWordCard is Future function,
                // I can not pass it in to a Function variable
                // so wrap it with another Function :)
                onPressed: () {
                  _onPressedWordCard(items, index);
                });
          },
        ),
      ),
    );
  }
}
