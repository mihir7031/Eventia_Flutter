import 'package:flutter/material.dart';
import 'package:eventia/Favorite/favorit_page.dart';
import 'package:eventia/view/profile.dart';
import 'package:eventia/Event_info/Event_info.dart';
import 'package:eventia/Add_event/CreateEventForm.dart';

class screenmain extends StatefulWidget {
  const screenmain({super.key});

  @override
  State<screenmain> createState() => _screenmainState();
}

class _screenmainState extends State<screenmain> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 4) {
      // Profile tab is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => profile()),
      );
    } else if (index == 3) {
      // Favorite tab is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => favorite_page()),
      );
    } else if (index == 2) {
      // Favorite tab is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateEventForm()),
      );
    }
  }

  void _onCardTapped() {
    // Handle card tap here, e.g., navigate to another screen or show a dialog
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Event_info()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[400],
        title: Row(
          children: [
            Image.asset(
              'assets/planner.png', // Your app logo
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text('E', style: TextStyle(fontFamily: 'Blacksword')),
            const Text('ventia', style: TextStyle(fontFamily: 'BeautyDemo')),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.nights_stay), // Night mode icon
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert), // More icon
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/mainscreen_img.jpg', fit: BoxFit.cover),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(6, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Column(
                            children: [
                              Icon(Icons.sports, color: Colors.lightBlue[400]),
                              const Text('Sport',
                                  style: TextStyle(color: Colors.lightBlue)),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Column(
                            children: [
                              Icon(Icons.filter_list, color: Colors.grey),
                              const Text('Filters',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: List.generate(5, (index) {
                return InkWell(
                  onTap:
                      _onCardTapped, // Define what happens when the card is tapped
                  child: Card(
                    margin: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SizedBox(
                            width: 100.0, // Adjust the width as needed
                            height:
                                150.0, // Ensure this height matches the desired card height
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Optional: to match the card's border radius
                              child: Image.asset(
                                'assets/card_img1.jpg',
                                fit: BoxFit
                                    .cover, // To ensure the image covers the entire space
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fri, Jun 5  7:00PM IST',
                                  style: TextStyle(color: Colors.red),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'Lorem Ipsum is simply dummy text of the ',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5.0),
                                Text('By Eventia'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.share),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.favorite_border),
                                      onPressed: () {},
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
            label: 'Favourite',
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
