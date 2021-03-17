import 'package:flutter/material.dart';

class SharedAppBar extends StatelessWidget {
  SharedAppBar({
    @required this.size,
    @required this.title,
    @required this.backgroundColor,
    @required this.icon,
    this.onPressed,
  });

  final Size size;
  final String title;
  final Color backgroundColor;
  final Icon icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      toolbarHeight: size.height * 0.1,
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
          child: RawMaterialButton(
            child: icon,
            onPressed: onPressed,
            elevation: 3.0,
            constraints: BoxConstraints.tightFor(
              width: 40.0,
              height: 40.0,
            ),
            shape: CircleBorder(), // Button Tròn
            fillColor: Colors.white,
          ),
        ),
      ],
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
    );
  }
}
