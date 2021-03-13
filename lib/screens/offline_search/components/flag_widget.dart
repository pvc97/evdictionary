import 'package:flutter/material.dart';

class FlagWidget extends StatelessWidget {
  FlagWidget({this.language});

  final String language;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: EdgeInsets.all(7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/${language.toLowerCase()}.png',
            width: 25,
            height: 25,
          ),
          Text(
            ' $language',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
