import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  final List<Map<String, String>> favoriteEvents;

  const FavoritePage({super.key, required this.favoriteEvents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Events', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightBlue[300],
      ),
      body: favoriteEvents.isEmpty
          ? Center(child: Text('No favorite events added yet.', style: TextStyle(fontSize: 18)))
          : ListView.builder(
        itemCount: favoriteEvents.length,
        itemBuilder: (context, index) {
          final event = favoriteEvents[index];
          return InkWell(
            onTap: () {
              // Handle card tap if needed
            },
            child: Card(
              margin: EdgeInsets.all(10.0),
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
                          event['image'] ?? 'assets/card_img1.jpg',
                          fit: BoxFit.cover,
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
                            event['date'] ?? 'Date not available',
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            event['title'] ?? 'Title not available',
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5.0),
                          Text(event['subtitle'] ?? 'Subtitle not available'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.favorite),
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
        },
      ),
    );
  }
}