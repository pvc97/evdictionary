import 'package:ev_dictionary/screens/favorite/favorite_screen.dart';
import 'package:ev_dictionary/screens/offline_search/offline_search_screen.dart';
import 'package:ev_dictionary/screens/online/online_search_screen.dart';
import 'package:flutter/material.dart';
import 'utilities/constaints.dart';
import 'screens/offline_search/offline_search_screen.dart';
import 'screens/history/history_screen.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    OfflineSearchScreen(),
    HistoryScreen(),
    FavoriteScreen(),
    OnlineSearchScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withOpacity(0.2),
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
                backgroundColor: kBackgroundColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.access_time),
                label: 'History',
                backgroundColor: kBackgroundColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star_border_rounded),
                label: 'Favorite',
                backgroundColor: kBackgroundColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.public),
                label: 'Online',
                backgroundColor: kBackgroundColor,
              ),
            ],
            currentIndex: _selectedIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black,
            // reduce the extra padding on top and bottom of the nav bar
            // by set selectedFontSize and unselectedFontSize to 1.0
            selectedFontSize: 1.0,
            unselectedFontSize: 1.0,
            selectedIconTheme: IconThemeData(
              size: 30.0,
            ),
            unselectedIconTheme: IconThemeData(
              size: 20.0,
            ),
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
