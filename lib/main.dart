import 'package:ev_dictionary/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'utilities/constaints.dart';
import 'utilities/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future loadDatabase() {
    return DatabaseHelper.instance.database;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EV DICTIONARY',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: kPrimaryColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: loadDatabase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Navigation();
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return LoadingScreen();
        },
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SpinKitFadingCircle(
            color: Colors.blue,
            size: 50,
          ),
        ),
      ),
    );
  }
}
