import 'package:eventia/Event_info/booking.dart';
import 'package:flutter/material.dart';
import 'package:eventia/main.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';// Importing the main.dart for color constants

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
                        image: NetworkImage(widget.event['eventPoster'] ??
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

                              Builder(
                                builder: (context) {
                                  Timestamp? timestamp = widget.event['selectedDate'] as Timestamp?;
                                  String formattedDate;

                                  if (timestamp != null) {
                                    DateTime dateTime = timestamp.toDate();
                                    formattedDate = DateFormat('dd-MM-yy').format(dateTime);
                                  } else {
                                    formattedDate = 'Date Not Available';
                                  }

                                  return Text(formattedDate); // Use formatted date
                                },
                              ),

                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.access_time, color: primaryColor),
                              const SizedBox(width: 8),
                              Text(widget.event['selectedTime'] ?? 'Time Not Available'),
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
                                  widget.event['isOnline'] != true
                                      ? 'Online Event' // Display this if isOnline is true
                                      : widget.event['location'] ?? 'Location Not Available', // Display location or fallback text
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
                  // const Text(
                  //   'Event Highlights',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 18,
                  //   ),
                  // ),
                  // const SizedBox(height: 8),
                  // Text(widget.event['eventHighlights'] ?? 'No highlights available.'),
                  // const SizedBox(height: 16),
                  // const Text(
                  //   'Artist',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 18,
                  //   ),
                  // ),
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
                  // const SizedBox(height: 16),
                  // const Text(
                  //   'Accessibility Information',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 18,
                  //   ),
                  // ),
                  // const SizedBox(height: 8),
                  // // Text(widget.event['accessibilityInfo'] ?? 'No accessibility information provided.'),
                  // const SizedBox(height: 16),


                  // _buildFieldsSection(widget.event['fields'] ?? []),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.event['fields'].map<Widget>((field) {
            if (field['type'] == 'text') {
              // Display text fields
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Colors.grey),
                  Text(
                    field['title'] ?? 'Untitled',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    field['description'] ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            } else if (field['type'] == 'photo') {
              // Display photo fields
              List<dynamic> imagePaths = field['imagePaths'] ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Colors.grey),
                  Text(
                    field['title'] ?? 'Untitled',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (imagePaths.isNotEmpty)
                    Column(
                      children: [
                        // Show max 3 images in a row using GridView
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // Show 3 images per row
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: imagePaths.length > 3 ? 3 : imagePaths.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () =>
                                  _showFullScreenImage(context, imagePaths, index),
                              child: Image.network(
                                imagePaths[index],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                        if (imagePaths.length > 3)
                          TextButton(
                            onPressed: () => _showMoreImages(context, imagePaths),
                            child: const Text('See More'),
                          ),
                      ],
                    )
                  else
                    const Text('No images available.'),
                  const SizedBox(height: 16),
                ],
              );
            } else if (field['type'] == 'file') {
              // Display file fields (file links)
              List<dynamic> fileLinks = field['fileLinks'] ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Colors.grey),
                  Text(
                    field['title'] ?? 'Untitled',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (fileLinks.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: fileLinks.map((fileLink) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () => _openFileLink(fileLink),
                              child: Text(
                                fileLink,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      }).toList(),
                    )
                  else
                    const Text('No files available.'),
                  const SizedBox(height: 16),
                ],
              );
            }
            return Container();
          }).toList(),
        ),

        const SizedBox(height: 16),

                  Row(
                    children: [
                      // Expanded(
                      //   child: Text(
                      //     '₹${widget.event['price'] ?? '0'} onwards',
                      //     style: const TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 18,
                      //       color: Colors.red,
                      //     ),
                      //   ),
                      // ),
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


// Function to show a full-screen image viewer
void _showFullScreenImage(BuildContext context, List<dynamic> imagePaths, int initialIndex) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FullScreenImageViewer(imagePaths: imagePaths, initialIndex: initialIndex),
    ),
  );
}

// Function to show all images when "See More" is clicked
void _showMoreImages(BuildContext context, List<dynamic> imagePaths) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ImageGridViewer(imagePaths: imagePaths),
    ),
  );
}

// Full-screen image viewer widget
class FullScreenImageViewer extends StatelessWidget {
  final List<dynamic> imagePaths;
  final int initialIndex;

  const FullScreenImageViewer({Key? key, required this.imagePaths, required this.initialIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: PageView.builder(
          itemCount: imagePaths.length,
          controller: PageController(initialPage: initialIndex),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => Navigator.pop(context), // Exit full screen on tap
              child: Image.network(
                imagePaths[index],
                fit: BoxFit.contain,
              ),
            );
          },
        ),
      ),
    );
  }
}

// Widget to display all images in a grid view
class ImageGridViewer extends StatelessWidget {
  final List<dynamic> imagePaths;

  const ImageGridViewer({Key? key, required this.imagePaths}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Images"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: imagePaths.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _showFullScreenImage(context, imagePaths, index),
              child: Image.network(
                imagePaths[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}

// Function to open file link
void _openFileLink(String fileLink) {
  // You can use a package like url_launcher to open the file link
  // Example: launchUrl(fileLink);
  print("Opening file: $fileLink");
}
