import 'package:flutter/material.dart';

class JoinedEventDetailsPage extends StatelessWidget {
  const JoinedEventDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EEEA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back arrow and favorite button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back arrow button
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.black,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    // Favorite button
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border),
                        color: Colors.black,
                        onPressed: () {
                          // Handle favorite action
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Event details rectangle
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image and details row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event image
                          Container(
                            width: 120, // Decreased width
                            height: 160, // Increased height
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8.0), // Added radius
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.image, color: Colors.white),
                          ),
                          const SizedBox(width: 16.0),
                          // Event details
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Event Name: DJ Night by DJ Olly',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF282828),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Language: English',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFF282828),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Day: Friday',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFF282828),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Date: Jun 5, 2024',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFF282828),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Time: 7:00 PM IST',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFF282828),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Location: XYZ Venue',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFF282828),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      // Ticket details heading
                      const Text(
                        'Ticket Details',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF282828),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      // Ticket details box
                      Container(
                        padding: const EdgeInsets.only(left: 12.0,top: 14,bottom: 14,right: 3.4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD8E0E8),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // QR Code
                            Container(
                              width: 80, // Adjust width as needed
                              height: 80, // Adjust height as needed
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.qr_code, color: Colors.white),
                            ),
                            const SizedBox(width: 16.0),
                            // Ticket details
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Booking ID, Total Units, and Total Price
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Booking ID:',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF282828),
                                            ),
                                          ),
                                          SizedBox(height: 10.0),
                                          Text(
                                            'Total Units:',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF282828),
                                            ),
                                          ),
                                          SizedBox(height: 10.0),
                                          Text(
                                            'Total Price:',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF282828),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '12345670',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF282828),
                                            ),
                                          ),
                                          SizedBox(height: 10.0),
                                          Text(
                                            '2',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF282828),
                                            ),
                                          ),
                                          SizedBox(height: 10.0),
                                          Text(
                                            '5000.00',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF282828),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Additional event-related details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description: Join us for an amazing night of music with DJ Olly.',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF282828),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // Certificates section
                    const Text(
                      'Certificates:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF282828),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Card(
                      color: const Color(0xFFD8E0E8),
                      child: ListTile(
                        title: const Text('Download Certificate'),
                        trailing: const Icon(Icons.download),
                        onTap: () {
                          // Handle certificate download
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // Common Chat section
                    const Text(
                      'Common Chat:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF282828),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD8E0E8),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Row(
                        children: [
                          // Chat icon
                          Icon(Icons.chat, color: Color(0xFF282828)),
                          SizedBox(width: 10.0),
                          // Chat text
                          Expanded(
                            child: Text(
                              'Join the conversation and share your experience!',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Color(0xFF282828),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // Q&A section
                    const Text(
                      'Q&A:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF282828),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Card(
                      color: const Color(0xFFD8E0E8),
                      child: ListTile(
                        title: const Text('Ask a Question'),
                        trailing: const Icon(Icons.question_answer),
                        onTap: () {
                          // Handle asking a question
                        },
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    // Example Q&A items
                    const Card(
                      color: Color(0xFFD8E0E8),
                      child: ListTile(
                        title: Text('Q: What time should I arrive?'),
                        subtitle: Text(
                          'A: The event starts at 7:00 PM, so arriving 15 minutes early is recommended.',
                        ),
                      ),
                    ),
                    const Card(
                      color: Color(0xFFD8E0E8),
                      child: ListTile(
                        title: Text('Q: Is parking available?'),
                        subtitle: Text('A: Yes, there is ample parking space at the venue.'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}