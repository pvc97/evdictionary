import 'package:ev_dictionary/screens/definition/components/shared_appbar.dart';
import 'package:ev_dictionary/screens/definition/definition_screen.dart';
import 'package:ev_dictionary/screens/history/components/word_card.dart';
import 'package:ev_dictionary/utilities/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ev_dictionary/utilities/constaints.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ev_dictionary/utilities/database_helper.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Word> items = [];

  Future<List> _getListFavorite() async {
    Database db = await DatabaseHelper.instance.database;

    List<Map> result = await db.rawQuery(
        'SELECT * FROM av WHERE favorite = 1 UNION SELECT * FROM va WHERE favorite = 2');

    List<Word> words = List.generate(
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
    words
        .sort((a, b) => (a.word.toLowerCase()).compareTo(b.word.toLowerCase()));

    return words;
  }

  void _loadFavorite() async {
    items = await _getListFavorite();
    setState(() {});
  }

  void _removeFavorite(Word item) async {
    Database db = await DatabaseHelper.instance.database;
    String tableName;

    if (item.favorite == 1) {
      tableName = 'av';
    } else {
      tableName = 'va';
    }
    db.rawQuery('UPDATE $tableName SET favorite = 0 WHERE id = ${item.id}');
  }

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.1),
        child: SharedAppBar(
          size: size,
          title: 'Favorite',
          backgroundColor: kEnglishAppbarColor,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        // ListView not in Column don't have to wrap by Expaned
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Dismissible(
              key: Key(item.id.toString() + '+' + item.favorite.toString()),
              onDismissed: (direction) {
                setState(() {
                  items.removeAt(index);
                });
                _removeFavorite(item);
              },
              child: WordCard(
                items: items,
                index: index,
                flagDir: items[index].favorite == 1
                    ? kEnglishFlagDir
                    : kVietNamFlagDir,
                // Because onPressedWordCard is Future function,
                // I can not pass it in to a Function variable
                // so wrap it with another Function :)
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => DefinitionScreen(
                        word: items[index],
                        translateType: items[index].favorite == 1
                            ? Translate.av
                            : Translate.va,
                      ),
                    ),
                  ).then((value) {
                    // Thêm dòng này để khi bỏ favorite ở trang definition
                    _loadFavorite(); // Thì sẽ rebuild lại để hiển thị cho đúng thực tế
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
