import 'package:ev_dictionary/utilities/constaints.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'components/switch_button.dart';
import 'components/flag_widget.dart';
import 'package:ev_dictionary/screens/definition/definition_screen.dart';
import 'package:ev_dictionary/utilities/database_helper.dart';
import 'package:ev_dictionary/utilities/word.dart';
import 'package:flutter/cupertino.dart';

class OfflineSearchScreen extends StatefulWidget {
  @override
  _OfflineSearchScreenState createState() => _OfflineSearchScreenState();
}

class _OfflineSearchScreenState extends State<OfflineSearchScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  Translate translateType = Translate.av;

  List<Word> items = [];

  Future<List> _getListWords(String word) async {
    Database db = await databaseHelper.database;

    String tableName;
    if (translateType == Translate.av) {
      tableName = 'av';
    } else {
      tableName = 'va';
    }

    List<Map> result = await db.rawQuery(
        'SELECT * from $tableName where word LIKE ? LIMIT 50', ['$word%']);

    List<Word> words = List.generate(
      result.length,
      (i) => Word(
        id: result[i]['id'],
        word: result[i]['word'],
        html: result[i]['html'],
        description: result[i]['description'],
        pronounce: result[i]['pronounce'],
      ),
    );
    words
        .sort((a, b) => (a.word.toLowerCase()).compareTo(b.word.toLowerCase()));
    return words;
  }

  // Insert to history table with 2 field are id and table
  void _insertToHistory(Word word) async {
    Database db = await databaseHelper.database;
    String tb;
    if (translateType == Translate.av) {
      tb = 'av';
    } else {
      tb = 'va';
    }

    // Column tb khong co primary key nen chen vao thoa mai

    // Khong can chen gia tri vao column position vi no la primary key
    // nen se tu tang len 1 moi khi insert
    db.rawQuery(
        '''INSERT INTO history (id, word, tb) VALUES (${word.id}, '${word.word}', '$tb')''');
  }

  void _changeTranslateType() {
    if (translateType == Translate.av) {
      translateType = Translate.va;
    } else {
      translateType = Translate.av;
    }

    _loadInitWords();
  }

  void _updateListWord(String value) async {
    List result = await _getListWords(value);
    setState(() {
      items = result;
    });
  }

  void _loadInitWords() async {
    List result = await _getListWords('');
    setState(() {
      items = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadInitWords();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Material(
      child: Column(
        children: [
          Container(
            height: size.height * 0.2,
            child: Stack(
              children: [
                Container(
                  height: size.height * 0.2 - 26,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: const Radius.circular(25),
                      bottomRight: const Radius.circular(25),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        kVietnameseAppbarColor,
                        kEnglishAppbarColor,
                      ],
                      begin: translateType == Translate.va
                          ? Alignment.topLeft
                          : Alignment.bottomRight,
                      end: translateType == Translate.av
                          ? Alignment.topLeft
                          : Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    // top: 20,
                    // left: 0,
                    // right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlagWidget(
                          language: translateType == Translate.va
                              ? 'Vietnamese'
                              : 'English',
                        ),
                        SwitchButton(
                          color: Colors.white,
                          onPressed: _changeTranslateType,
                        ),
                        FlagWidget(
                          language: translateType == Translate.av
                              ? 'Vietnamese'
                              : 'English',
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 40.0),
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10),
                      ],
                    ),
                    child: TextField(
                      autofocus: false,
                      style: const TextStyle(
                        fontSize: 22.0,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: kPrimaryColor,
                        ),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        FocusScope.of(context).unfocus();

                        if (items.isNotEmpty) {
                          _insertToHistory(items.first);
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => DefinitionScreen(
                                word: items.first,
                                translateType: translateType,
                              ),
                            ),
                          );
                        }
                      },
                      onChanged: (value) {
                        _updateListWord(value);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            // ListView in column need wrap by Expanded
            child: items.length > 0
                ? ListView.builder(
                    key: ObjectKey(items.hashCode),
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          _insertToHistory(items[index]);
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => DefinitionScreen(
                                word: items[index],
                                translateType: translateType,
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                translateType == Translate.av
                                    ? kEnglishFlagDir
                                    : kVietNamFlagDir,
                                width: 25,
                                height: 25,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                '${items[index].word}',
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
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
        ],
      ),
    );
  }
}
