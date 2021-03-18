import 'package:flutter/material.dart';

class WordCard extends StatelessWidget {
  const WordCard({
    @required this.items,
    @required this.index,
    this.onPressed,
    @required this.flagDir,
  });

  final List items;
  final int index;
  final Function onPressed;
  final String flagDir;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
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
        child: Row(
          children: [
            Image.asset(
              flagDir,
              width: 25,
              height: 25,
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              '${items[index].word}',
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
