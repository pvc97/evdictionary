import 'package:ev_dictionary/screens/offline_search/components/switch_button.dart';
import 'package:flutter/material.dart';
import 'package:ev_dictionary/screens/definition/components/shared_appbar.dart';
import 'package:ev_dictionary/utilities/constaints.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class OnlineSearchScreen extends StatefulWidget {
  @override
  _OnlineSearchScreenState createState() => _OnlineSearchScreenState();
}

class _OnlineSearchScreenState extends State<OnlineSearchScreen> {
  Translate translateType = Translate.av;
  String result = '';

  final translator = GoogleTranslator();
  final FlutterTts flutterTts = FlutterTts();

  Future _speak() async {
    if (translateType == Translate.av) {
      await flutterTts.setLanguage('vi-VN');
    } else if (translateType == Translate.va) {
      await flutterTts.setLanguage('en-US');
    }

    await flutterTts.setSpeechRate(0.8);
    await flutterTts.speak(result);
  }

  @override
  void initState() {
    super.initState();
    // To make keyboard doesn't pop up when open this screen
    Future.delayed(const Duration(),
        () => SystemChannels.textInput.invokeMethod('TextInput.hide'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.105),
        child: SharedAppBar(
          size: size,
          title: 'Online Search',
          backgroundColor: kEnglishAppbarColor,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: TextField(
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  // enabledBorder to make set color for border when unfocus
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  labelText: translateType == Translate.av
                      ? 'English - Vietnamese'
                      : 'Vietnamese - English',
                  hintText: "Tap to enter text",
                  fillColor: kBackgroundCardColor,
                  filled: true,
                ),
                style: TextStyle(
                  fontSize: 22.0,
                ),
                onChanged: (value) async {
                  // translator don't work with value start with ' ' or empty
                  // so I have to check it first
                  value = value.trim();
                  if (value.length > 0 && value[0] != ' ') {
                    String source;
                    String destination;
                    if (translateType == Translate.av) {
                      source = 'en';
                      destination = 'vi';
                    } else {
                      source = 'vi';
                      destination = 'en';
                    }

                    var translation = await translator.translate(value,
                        from: source, to: destination);
                    setState(() {
                      // Don't translate word with length == 1
                      // Because with word with 1 charactor
                      // the result will be wrong word
                      // Example (english to vietnamese): h -> hox
                      if (value.length == 1) {
                        result = '';
                      } else {
                        result = translation.toString();
                      }
                    });
                  }
                },
              ),
            ),
            SwitchButton(
              color: Colors.blue,
              onPressed: () {
                setState(() {
                  if (translateType == Translate.av) {
                    translateType = Translate.va;
                  } else {
                    translateType = Translate.av;
                  }
                });
              },
            ),
            // Wrap by Flexible remove A RenderFlex overflowed by ...
            // And I can add width: double.infinity, height: double.infinity to
            // Container without error :)
            Flexible(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.blue, width: 2),
                      color: kBackgroundCardColor,
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        result,
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: -20,
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
            ),
          ],
        ),
      ),
    );
  }
}
