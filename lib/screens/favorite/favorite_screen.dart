import 'package:flutter/material.dart';
import 'package:ev_dictionary/utilities/constaints.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<String> items = ['Xin Chao', 'Cac ban'];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: size.height * 0.1,
        title: Text(
          'Favorite',
          style: TextStyle(
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      body: CustomListView(
        items: items,
        onPressed: null,
        translateType: null,
      ),
    );
  }
}

class CustomListView extends StatelessWidget {
  CustomListView({
    @required this.items,
    @required this.onPressed,
    @required this.translateType,
  });

  final List<String> items;
  final Translate translateType;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
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
                    kVietNamFlagDir,
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    '${items[index]}',
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
