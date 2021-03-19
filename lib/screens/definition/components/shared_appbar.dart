import 'package:flutter/material.dart';

import 'custom_button.dart';

class SharedAppBar extends StatelessWidget {
  SharedAppBar({
    @required this.size,
    @required this.title,
    @required this.backgroundColor,
    this.customButton,
  });

  final Size size;
  final String title;
  final Color backgroundColor;
  final CustomButton customButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      toolbarHeight: size.height * 0.105,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 35.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(
            right: 10.0,
          ),
          // Using RawMaterialButton because IconButton don't have background color
          child: customButton,
        ),
      ],
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
    );
  }
}
