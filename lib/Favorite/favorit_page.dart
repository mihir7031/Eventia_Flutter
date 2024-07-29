import 'package:flutter/material.dart';

class favorite_page extends StatelessWidget {
  const favorite_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Page',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightBlue[300],
      ),
      body: Center(
        child: Text(
          'Your favorite events will be displayed here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
