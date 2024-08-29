import 'package:flutter/material.dart';
import 'package:eventia/view/screenmain.dart';
import 'package:eventia/view/profile.dart';
import 'package:eventia/Add_event/CreateEventForm.dart';

final List<Widget> _pages = [
  const ScreenMain(),
  const CreateEventForm(), // Assuming this is for adding events
  const CreateEventForm(), // Could be another page like SearchPage(),
  const CreateEventForm(), // Could be another page like FavoritesPage(),
];

class NavigatorWidget extends StatefulWidget {
  const NavigatorWidget({super.key});

  @override
  _NavigatorWidgetState createState() => _NavigatorWidgetState();
}

class _NavigatorWidgetState extends State<NavigatorWidget> {
  int _currentIndex = 0;

  Future<bool> _onWillPop() async {
    // Define your custom back button behavior here
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0; // Navigate to the home screen when back button is pressed
      });
      return false; // Prevents the default back action
    }
    return true; // Allows the default back action
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _pages[_currentIndex], // Show the selected page
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
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
              label: 'Favorites',
            ),

          ],
        ),
      ),
    );
  }
}
