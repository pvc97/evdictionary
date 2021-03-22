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

class _HistoryScreenState extends State<HistoryScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<History> items = [];

  Future<List> _getListHistories() async {
    Database db = await DatabaseHelper.instance.database;

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

  void _deleteAllHistory() async {
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

  void _removeHistory(History item) async {
    Database db = await DatabaseHelper.instance.database;

    db.rawQuery('DELETE FROM history WHERE position = ${item.position}');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _loadHistory();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar can phai de trong PreferredSize
      appBar: PreferredSize(
        // preferredSize and toolbarHeight in AppBar need
        // to equal to center appbar title in vertical
        preferredSize: Size.fromHeight(size.height * 0.1),
        child: SharedAppBar(
          size: size,
          title: 'History',
          backgroundColor: kEnglishAppbarColor,
          customButton: CustomButton(
            icon: const Icon(
              Icons.delete_sweep_rounded,
              color: Colors.blue,
            ),
            onPressed: _deleteAllHistory,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        // ListView not in Column don't have to wrap by Expaned
        child: ListView.builder(
          clipBehavior: Clip.none, // Fix shadow weird behavior
          physics: BouncingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Dismissible(
              key: Key(item.position.toString()),
              onDismissed: (direction) {
                setState(() {
                  items.removeAt(index);
                });
                _removeHistory(item);
              },
              child: WordCard(
                items: items,
                index: index,
                table: items[index].table,
                // Because onPressedWordCard is Future function,
                // I can not pass it in to a Function variable
                // so wrap it with another Function :)
                onPressed: () {
                  _onPressedWordCard(items, index);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
