import 'package:flutter/material.dart';

class FlagWidget extends StatelessWidget {
  FlagWidget({this.language});

  final String language;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 135,
      padding: EdgeInsets.all(7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/${language.toLowerCase()}.png',
            width: 30,
            height: 30,
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
