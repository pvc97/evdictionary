import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    @required this.icon,
    this.onPressed,
  });

  final Icon icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: icon,
      onPressed: onPressed,
      elevation: 3.0,
      constraints: BoxConstraints.tightFor(
        width: 40.0,
        height: 40.0,
      ),
      shape: CircleBorder(), // Button Tròn
      fillColor: Colors.white,
    );
  }
}