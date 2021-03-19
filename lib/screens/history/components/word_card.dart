import 'package:flutter/material.dart';
import 'package:ev_dictionary/utilities/constaints.dart';

class WordCard extends StatelessWidget {
  const WordCard({
    @required this.items,
    @required this.index,
    this.onPressed,
    @required this.table,
  });

  final List items;
  final int index;
  final Function onPressed;
  final String table;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(18.0),
        margin: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: table == 'av'
                ? [Colors.purple, Colors.blue]
                : [Colors.purple, Colors.red],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: table == 'av'
                  ? Colors.blue.withOpacity(0.4)
                  : Colors.red.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(4, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Image.asset(
              table == 'av' ? kEnglishFlagDir : kVietNamFlagDir,
              width: 25,
              height: 25,
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              '${items[index].word}',
              style: TextStyle(
                fontSize: 28.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// return InkWell(
//       onTap: onPressed,
//       borderRadius: BorderRadius.circular(20.0),
//       child: Container(
//         padding: EdgeInsets.all(20.0),
//         decoration: BoxDecoration(
//           border: Border(
//             bottom: BorderSide(
//               width: 1.0,
//               color: Colors.grey.withOpacity(0.2),
//             ),
//           ),
//         ),
//         child: Row(
//           children: [
//             Image.asset(
//               flagDir,
//               width: 25,
//               height: 25,
//             ),
//             SizedBox(
//               width: 20.0,
//             ),
//             Text(
//               '${items[index].word}',
//               style: TextStyle(
//                 fontSize: 25.0,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
