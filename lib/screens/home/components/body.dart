import 'package:ev_dictionary/constaints.dart';
import 'package:flutter/material.dart';
import 'switch_button.dart';
import 'flag_widget.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Translate translateType = Translate.av;

  void changeTranslateType() {
    setState(() {
      if (translateType == Translate.av) {
        translateType = Translate.va;
      } else {
        translateType = Translate.av;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.height * 0.2,
          child: Stack(
            children: [
              Container(
                height: size.height * 0.2 - 22,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlagWidget(
                      language: translateType == Translate.va
                          ? 'Vietnamese'
                          : 'English',
                    ),
                    SwitchButton(
                      onPressed: changeTranslateType,
                    ),
                    FlagWidget(
                      language: translateType == Translate.av
                          ? 'Vietnamese'
                          : 'English',
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40.0),
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextField(
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.only(right: 20.0),
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
                      print(value);
                    },
                    onChanged: (value) {
                      print(value);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            itemBuilder: (context, position) {
              return InkWell(
                onTap: () {
                  print('wow');
                },
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.0,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Text(
                    position.toString(),
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
