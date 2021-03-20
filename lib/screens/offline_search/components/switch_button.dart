import 'package:flutter/material.dart';

class SwitchButton extends StatelessWidget {
  SwitchButton({this.color, this.onPressed});

  final Color color;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: IconButton(
            icon: Icon(Icons.swap_horiz),
            color: color,
            iconSize: 30,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
