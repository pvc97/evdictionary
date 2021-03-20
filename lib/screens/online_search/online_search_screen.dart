import 'package:flutter/material.dart';
import 'package:ev_dictionary/screens/definition/components/shared_appbar.dart';
import 'package:ev_dictionary/utilities/constaints.dart';

class OnlineSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.105),
        child: SharedAppBar(
          size: size,
          title: 'Online Search',
          backgroundColor: kEnglishAppbarColor,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text('Online Search'),
        ),
      ),
    );
  }
}
