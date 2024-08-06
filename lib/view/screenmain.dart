// screen_main.dart
import 'package:flutter/material.dart';
import 'package:eventia/Favorite/favorit_page.dart';
import 'package:eventia/view/profile.dart';
import 'package:eventia/Event_info/Event_info.dart';
import 'package:eventia/Add_event/CreateEventForm.dart';
import 'popup_menu.dart';  // Import the custom popup menu

class ScreenMain extends StatefulWidget {
  const ScreenMain({super.key});

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  int _selectedIndex = 0;
  List<Map<String, String>> favoriteEvents = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateEventForm()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavoritePage(favoriteEvents: favoriteEvents)),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  void _onCardTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Event_info()),
    );
  }

  void _addFavoriteEvent(Map<String, String> event) {
    setState(() {
      favoriteEvents.add(event);
    });
  }

  void _onMenuOptionSelected(String value) {
    // Handle menu option selection
    switch (value) {
      case 'Settings':
      // Navigate to Settings page or perform an action
        break;
      case 'Logout':
      // Perform logout action
        break;
    // Add more cases as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            SizedBox(width: 10),
            Text('E', style: TextStyle(fontFamily: 'Blacksword', color: Colors.black)),
            Text('ventia', style: TextStyle(fontFamily: 'BeautyDemo', color: Colors.black)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          CustomPopupMenu(onMenuOptionSelected: _onMenuOptionSelected), // Use the custom popup menu
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        // Add your category click action here
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage('assets/posters/p${index+1}.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Sport',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your filter click action here
                      },
                      child: const Text('Filters'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your filter click action here
                      },
                      child: const Text('Date'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your filter click action here
                      },
                      child: const Text('Location'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your filter click action here
                      },
                      child: const Text('Type'),
                    ),
                  ),
                  // Add more filter buttons here if needed
                ],
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: List.generate(5, (index) {
                return InkWell(
                  onTap: _onCardTapped,
                  child: Card(
                    margin: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SizedBox(
                            width: 100.0,
                            height: 150.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/posters/p${index + 1}.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fri, Jun 5  7:00PM IST',
                                  style: TextStyle(color: Colors.red),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  'Lorem Ipsum is simply dummy text of the ',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 5.0),
                                const Text('By Eventia'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.share),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.favorite_border),
                                      onPressed: () {
                                        _addFavoriteEvent({
                                          'date': 'Fri, Jun 5  7:00PM IST',
                                          'title': 'Lorem Ipsum is simply dummy text of the ',
                                          'subtitle': 'By Eventia',
                                          'image': 'assets/card_img1.jpg',
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue[400],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
