import 'package:flutter/material.dart';
import 'package:eventia/main.dart';
import 'package:eventia/Event_info/Event_info.dart';
import 'package:eventia/joinedEvent/joinedEventInfo.dart';

class JoinedEvent extends StatefulWidget {
  @override
  _JoinedEventState createState() => _JoinedEventState();
}

class _JoinedEventState extends State<JoinedEvent> {
  void _onCardTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JoinedEventDetailsPage()),
    );
  }

  final List<String> _events = [
    'Event 1',
    'Event 2',
    'Event 3',
    'Event 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
        title: Text('Joined Event', style: TextStyle(color: secondaryColor)),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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

  void _addFavoriteEvent(Map<String, String> eventDetails) {
    // Implement your favorite event logic here
  }
}
