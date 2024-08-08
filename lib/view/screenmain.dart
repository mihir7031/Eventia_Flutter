import 'package:flutter/material.dart';
import 'package:eventia/Favorite/favorit_page.dart';
import 'package:eventia/view/profile.dart';
import 'package:eventia/Event_info/Event_info.dart';
import 'package:eventia/Add_event/CreateEventForm.dart';
import 'package:eventia/main.dart';
import 'package:eventia/MyEvent/MyEventPage.dart';
import 'package:eventia/joinedEvent/joinedEvent.dart';


class ScreenMain extends StatefulWidget {
  const ScreenMain({super.key});

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  int _selectedIndex = 0;
  List<Map<String, String>> favoriteEvents = [];
  final FocusNode _searchFocusNode = FocusNode();

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
          MaterialPageRoute(
              builder: (context) =>
                  FavoritePage(favoriteEvents: favoriteEvents)),
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
    switch (value) {
      case 'Settings':
        // Navigate to Settings page or perform an action
        break;
      case 'Logout':
        // Perform logout action
        break;
    }
  }

  @override
  void dispose() {
    _searchFocusNode.dispose(); // Dispose the FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        backgroundColor:Colors.white,
        title: Row(
          children: const [
            SizedBox(width: 10),
            Text('E',
                style:
                    TextStyle(fontFamily: 'Blacksword', color: primaryColor)),
            Text('ventia',
                style:
                    TextStyle(fontFamily: 'BeautyDemo', color: primaryColor)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor, // Background color
                shape: BoxShape.circle, // Circular shape
              ),
              child: IconButton(
                icon: Icon(Icons.notifications, color: primaryColor),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor, // Change this to your desired color
              ),
              accountName: Text("Meet Prajapati"),
              accountEmail: Text("mm@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "O",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('My Events'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyEventPage()),
                );
                // Handle My Events action
              },
            ),
            ListTile(
              leading: Icon(Icons.event_available),
              title: Text('Joined Events'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JoinedEvent()),
                );
                // Handle Joined Events action
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Handle Settings action
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Login/Logout'),
              onTap: () {
                Navigator.pop(context);
                // Handle Login/Logout action
              },
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search, color: primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: cardColor, // Light Greenish-Gray background
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor, // Background color
                        shape: BoxShape.circle, // Circular shape
                      ),
                      child: IconButton(
                        icon: Icon(Icons.filter_list, color: primaryColor),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
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
                              width: 120,
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/posters/r${index + 1}.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Sport',
                              style: TextStyle(color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: List.generate(5, (index) {
                  return InkWell(
                    onTap: _onCardTapped,
                    child: Card(
                      color: cardColor,
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
                                    style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'TCF LINE UP Intercity Comedy',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 5.0),
                                  const Text('By Eventia',
                                      style: TextStyle(color: primaryColor)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.share,
                                            color: primaryColor),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.favorite_border,
                                            color: primaryColor),
                                        onPressed: () {
                                          _addFavoriteEvent({
                                            'date': 'Fri, Jun 5  7:00PM IST',
                                            'title':
                                                'Lorem Ipsum is simply dummy text of the ',
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
      ),
    );
  }
}
