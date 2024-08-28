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

  void _showTermsAndConditions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: AlertDialog(
            title: const Text('Terms & Conditions'),
            content: const SingleChildScrollView(
              child: Text(
                'These are the terms and conditions for the event...',
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Next'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Add your navigation code here
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRequirements(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: AlertDialog(
            title: const Text('Requirements'),
            content: const SingleChildScrollView(
              child: Text(
                'These are the requirements for attending the event...',
              ),
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
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
        title: const Text('Event Detail', style: TextStyle(color: secondaryColor)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://example.com/event-image.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black54, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    'Comedy Shows',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
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
                          const Text(
                            'TCF LINE UP - Intercity Comedy Show: Anand',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.calendar_today, color: primaryColor),
                              SizedBox(width: 8),
                              Text('Thu 1 Aug 2024'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.access_time, color: primaryColor),
                              SizedBox(width: 8),
                              Text('8:00 PM'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.timer, color: primaryColor),
                              SizedBox(width: 8),
                              Text('1 hour 30 minutes'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.person, color: primaryColor),
                              SizedBox(width: 8),
                              Text('Age Limit - 18yrs+'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.language, color: primaryColor),
                              SizedBox(width: 8),
                              Text('Gujarati, Hindi, English'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.category, color: primaryColor),
                              SizedBox(width: 8),
                              Text('Comedy'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: primaryColor),
                              const SizedBox(width: 8),
                              const Text('PiBy2 Cafe: Anand'),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () {},
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
                    _isExpanded
                        ? "The Comedy Factory brings to you TCF Line ups, a show where three comedians from Gujarat, Om Bhatt, Harshil Pandya and Jeel Aagja bring to you their hilarious set of jokes, stories and more. This event promises to be a laughter riot that you dont want to miss! The event will also feature a special segment with surprise guests and interactive sessions with the audience, making it a truly immersive comedy experience. Whether you're a fan of stand-up, improv, or just looking for a fun night out, this show has something for everyone. Come prepared to laugh until your sides hurt, and make sure to arrive early to grab the best seats in the house. Snacks and beverages will be available at the venue to keep you refreshed throughout the event. We look forward to seeing you there for an unforgettable night of comedy!"
                    : "The Comedy Factory brings to you TCF Line ups, a show where three comedians from Gujarat, Om Bhatt, Harshil Pandya and Jeel Aagja bring to you their hilarious set of jokes, stories and more...'",
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
                    'Requirements',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showRequirements(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info, color: primaryColor),
                          SizedBox(width: 8),
                          Text('Click to see requirements'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Artist',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: accentColor3,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage('https://example.com/artist-image.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Om Bhatt\nActor'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showTermsAndConditions(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.description, color: primaryColor),
                          SizedBox(width: 8),
                          Text('Click to see terms and conditions'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Organizer Contact Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Email: organizer@example.com\nPhone: +91 98765 43210',
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
                  const Text(
                    '1. Live comedy performances by top comedians.\n2. Interactive sessions with the performers.\n3. Delicious food and beverages.',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'FAQs',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Q: What time should I arrive?\nA: Please arrive at least 30 minutes before the event starts.\n\nQ: Are there any age restrictions?\nA: Yes, the event is restricted to individuals 18 years and older.',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Accessibility Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'The venue is wheelchair accessible and provides assistance for guests with special needs.',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Connect with Us',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.facebook, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Facebook'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.photo, color: Colors.purple), // Placeholder for Instagram
                      SizedBox(width: 8),
                      Text('Instagram'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          '₹199 onwards',
                          style: TextStyle(
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
                          backgroundColor: WidgetStateProperty.all(primaryColor),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          overlayColor: WidgetStateProperty.all(accentColor),
                        ),
                        child: const Text('Register Now', style: TextStyle(color: secondaryColor)),
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
