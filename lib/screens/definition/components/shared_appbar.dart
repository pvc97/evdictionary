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
      toolbarHeight: size.height * 0.1,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(
            right: 10,
          ),
          // Using RawMaterialButton because IconButton don't have background color
          child: customButton,
        ),
      ],
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          bottomLeft: const Radius.circular(20),
          bottomRight: const Radius.circular(20),
        ),
      ),
    );
  }
}
