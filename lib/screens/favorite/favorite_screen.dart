import 'package:ev_dictionary/screens/definition/components/shared_appbar.dart';
import 'package:ev_dictionary/screens/definition/definition_screen.dart';
import 'package:ev_dictionary/screens/history/components/word_card.dart';
import 'package:ev_dictionary/utilities/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ev_dictionary/utilities/constaints.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ev_dictionary/utilities/database_helper.dart';
import 'components/favorite.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Favorite> favoriteItems = [];

  Future<List> _getListFavorite() async {
    Database db = await DatabaseHelper.instance.database;

    List<Map> result = await db.rawQuery('SELECT * FROM favorite');

    List<Favorite> favorites = List.generate(
      result.length,
      (i) => Favorite(
        id: result[i]['id'],
        word: result[i]['word'],
        table: result[i]['tb'],
      ),
    );
    favorites
        .sort((a, b) => (a.word.toLowerCase()).compareTo(b.word.toLowerCase()));

    return favorites;
  }

  void _loadFavorite() async {
    favoriteItems = await _getListFavorite();
    setState(() {});
  }

  void _deleteSelectedFavorite(Favorite item) async {
    Database db = await DatabaseHelper.instance.database;
    String tableName = item.table;

    db.rawQuery(
        '''DELETE FROM favorite WHERE id = ${item.id} AND tb = '$tableName' ''');
  }

  Future _onPressedFavoriteItem(List items, int index) async {
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
    ).then((value) {
      // Thêm dòng này để khi bỏ favorite ở trang definition
      // Thì sẽ rebuild lại để hiển thị cho đúng thực tế
      _loadFavorite();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _loadFavorite();

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
        margin: const EdgeInsets.all(20),
        // ListView not in Column don't have to wrap by Expaned
        child: favoriteItems.length > 0
            ? ListView.builder(
                physics: BouncingScrollPhysics(),
                clipBehavior: Clip.none, // Fix shadow weird behavior
                itemCount: favoriteItems.length,
                itemBuilder: (context, index) {
                  final item = favoriteItems[index];
                  return Dismissible(
                    key: Key(item.id.toString() + item.table),
                    onDismissed: (direction) {
                      setState(() {
                        favoriteItems.removeAt(index);
                      });
                      _deleteSelectedFavorite(item);
                    },
                    child: WordCard(
                      items: favoriteItems,
                      index: index,
                      table: favoriteItems[index].table,
                      // Because onPressedWordCard is Future function,
                      // I can not pass it in to a Function variable
                      // so wrap it with another Function :)
                      onPressed: () {
                        _onPressedFavoriteItem(favoriteItems, index);
                      },
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  'Empty!',
                  style: TextStyle(fontSize: 20),
                ),
              ),
      ),
    );
  }
}
