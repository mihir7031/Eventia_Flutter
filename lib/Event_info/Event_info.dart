import 'package:eventia/Event_info/booking.dart';
import 'package:flutter/material.dart';
import 'package:eventia/main.dart';  // Importing the main.dart for color constants

class Event_info extends StatefulWidget {
  final dynamic event;
  const Event_info({super.key, required this.event});
  @override
  _Event_infoState createState() => _Event_infoState();
}

class _Event_infoState extends State<Event_info> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  // void _showTermsAndConditions(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AnimatedContainer(
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeInOut,
  //         child: AlertDialog(
  //           title: const Text('Terms & Conditions'),
  //           content: const SingleChildScrollView(
  //             child: Text('These are the terms and conditions for the event...'),
  //           ),
  //           actions: [
  //             TextButton(
  //               child: const Text('Cancel'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             TextButton(
  //               child: const Text('Next'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //                 // Add your navigation code here
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // void _showRequirements(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AnimatedContainer(
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeInOut,
  //         child: AlertDialog(
  //           title: const Text('Requirements'),
  //           content: const SingleChildScrollView(
  //             child: Text('These are the requirements for attending the event...'),
  //           ),
  //           actions: [
  //             TextButton(
  //               child: const Text('OK'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
        backgroundColor: primaryColor,
        title: Text(
          widget.event['eventName'] ?? 'Event Detail',
          style: const TextStyle(color: secondaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.event['imageUrl'] ??
                            'https://example.com/default-image.jpg'),
                        fit:BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  // Container(
                  //   height: 400,
                  //   decoration: const BoxDecoration(
                  //     gradient: LinearGradient(
                  //       colors: [Colors.black54, Colors.transparent],
                  //       begin: Alignment.bottomCenter,
                  //       end: Alignment.topCenter,
                  //     ),
                  //   ),
                  // ),
                  // Positioned(
                  //   bottom: 15,
                  //   left: 40,
                  //   child: Text(
                  //     widget.event['eventName'] ?? 'Event Title',
                  //     style: const TextStyle(
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 24,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.event['eventName'] ?? 'Event Title',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, color: primaryColor),
                              const SizedBox(width: 8),
                              Text(widget.event['date'] ?? 'Date Not Available'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.access_time, color: primaryColor),
                              const SizedBox(width: 8),
                              Text(widget.event['time'] ?? 'Time Not Available'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.timer, color: primaryColor),
                              const SizedBox(width: 8),
                              Text(widget.event['duration'] ?? 'Duration Not Available'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.people, color: primaryColor),
                              const SizedBox(width: 8),
                              Text('Capacity: ${widget.event['capacity'] ?? 'N/A'}'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: primaryColor),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  widget.event['location'] ?? 'Location Not Available',
                                  style: const TextStyle(fontSize: 16),
                                  overflow: TextOverflow.ellipsis, // Add ellipsis if the text overflows
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () {
                                  // Add navigation to maps here
                                },
                                child: const Text(
                                  'View On Maps',
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'About The Event',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.event['location'] ?? 'Location Not Available',
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,  // Adds ellipsis if the text overflows
                    maxLines: 1,
                  ),
                  GestureDetector(
                    onTap: _toggleExpansion,
                    child: Text(
                      _isExpanded ? 'Read Less' : 'Read More',
                      style: const TextStyle(color: primaryColor),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Event Highlights',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.event['eventHighlights'] ?? 'No highlights available.'),
                  const SizedBox(height: 16),
                  const Text(
                    'Artist',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Row(
                  //   children: [
                  //     Container(
                  //       width: 60,
                  //       height: 60,
                  //       decoration: BoxDecoration(
                  //         color: accentColor3,
                  //         shape: BoxShape.circle,
                  //         image: DecorationImage(
                  //           image: NetworkImage(widget.event['artistImage'] ??
                  //               'https://example.com/default-artist.jpg'),
                  //           fit: BoxFit.cover,
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 8),
                  //     Text('${widget.event['artistName'] ?? 'Artist Name'}\n${widget.event['artistProfession'] ?? 'Profession'}'),
                  //   ],
                  // ),
                  const SizedBox(height: 16),
                  const Text(
                    'Accessibility Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.event['accessibilityInfo'] ?? 'No accessibility information provided.'),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '₹${widget.event['price'] ?? '0'} onwards',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BookingPage()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(primaryColor),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Register Now',
                          style: TextStyle(color: secondaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
