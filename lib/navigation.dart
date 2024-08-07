import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventia/Favorite/favorit_page.dart';
import 'package:eventia/view/screenmain.dart';
import 'package:eventia/view/profile.dart';
import 'package:eventia/Event_info/Event_info.dart';
import 'package:eventia/Add_event/CreateEventForm.dart';
import 'package:eventia/main.dart';
import 'package:eventia/view/screenmain.dart';

class PersistentNavBar extends StatefulWidget {

  final int selectedIndex;

  const PersistentNavBar(
      {required this.selectedIndex, Key? key})
      : super(key: key);

  @override
  _PersistentNavBarState createState() => _PersistentNavBarState();
}

class _PersistentNavBarState extends State<PersistentNavBar> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(

      tabBar: CupertinoTabBar(
        backgroundColor: accentColor3,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        // currentIndex: widget.selectedIndex,
        // onTap: widget.onItemSelected,
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(child: ScreenMain());
                // CupertinoTabView
              },
            );
          case 1:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(child: CreateEventForm());
                // CupertinoTabView
              },
            );
          case 2:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(child: CreateEventForm());
                // CupertinoTabView
              },
            );
          case 3:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(child: CreateEventForm());
                // CupertinoTabView
              },
            );
          case 4:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(child: ProfilePage());// CupertinoTabView
              },
            );
        }
        return Container();
      },
    );
  }
  }