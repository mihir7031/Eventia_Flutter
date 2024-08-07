import 'package:flutter/material.dart';
import 'package:eventia/main.dart';
import 'package:eventia/Event_info/Event_info.dart';

class MyEventPage extends StatefulWidget {
  @override
  _MyEventPageState createState() => _MyEventPageState();
}

class _MyEventPageState extends State<MyEventPage> {
  int _selectedIndex = 0;

  void _onCardTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Event_info()),
    );
  }

  final List<String> _events = [
    'Event 1',
    'Event 2',
    'Event 3',
    'Event 4',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor3,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.red, // Change this to your desired color
        ),
        title: Text('Event Management', style: TextStyle(color: secondaryColor)),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Option buttons
            Container(
              color: accentColor3,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildOptionButton('Live Event', 0),
                    _buildOptionButton('Finished Event', 1),
                    _buildOptionButton('Scheduled Event', 2),
                  ],
                ),
              ),
            ),
            // Event cards
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Prevent scrolling on this ListView
              itemCount: _events.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: _onCardTapped,
                  child: Card(
                    color: cardColor, // Ensure cardColor is defined
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
                                const Text('By Eventia',
                                    style: TextStyle(color: primaryColor)), // Ensure primaryColor is defined
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
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String text, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () => _onItemTapped(index),

        child: Text(
          text,
          style: TextStyle(
            color: _selectedIndex == index ? cardColor : primaryColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedIndex == index ? primaryColor : cardColor,
        ),
      ),
    );
  }

  void _addFavoriteEvent(Map<String, String> eventDetails) {
    // Implement your favorite event logic here
  }
}
