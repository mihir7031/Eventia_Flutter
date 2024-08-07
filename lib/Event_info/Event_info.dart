import 'package:eventia/Event_info/booking.dart';
import 'package:flutter/material.dart';
import 'package:eventia/main.dart';  // Importing the main.dart for color constants

class Event_info extends StatelessWidget {
  void _showTermsAndConditions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: AlertDialog(
            title: Text('Terms & Conditions'),
            content: SingleChildScrollView(
              child: Text(
                'These are the terms and conditions for the event...',
              ),
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Next'),
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
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: AlertDialog(
            title: Text('Requirements'),
            content: SingleChildScrollView(
              child: Text(
                'These are the requirements for attending the event...',
              ),
            ),
            actions: [
              TextButton(
                child: Text('OK'),
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
      backgroundColor: accentColor3,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.red, // Change this to your desired color
        ),

          backgroundColor: primaryColor,
        title: Text('Event Detail', style: TextStyle(color: secondaryColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 200,
                    color: accentColor2,
                  ),
                  Icon(Icons.play_circle_outline, size: 50, color: primaryColor),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comedy Shows',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'TCF LINE UP - Intercity Comedy Show: Anand',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: primaryColor),
                        SizedBox(width: 8),
                        Text('Thu 1 Aug 2024'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: primaryColor),
                        SizedBox(width: 8),
                        Text('8:00 PM'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.timer, color: primaryColor),
                        SizedBox(width: 8),
                        Text('1 hour 30 minutes'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person, color: primaryColor),
                        SizedBox(width: 8),
                        Text('Age Limit - 18yrs+'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.language, color: primaryColor),
                        SizedBox(width: 8),
                        Text('Gujarati, Hindi, English'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.category, color: primaryColor),
                        SizedBox(width: 8),
                        Text('Comedy'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: primaryColor),
                        SizedBox(width: 8),
                        Text('PiBy2 Cafe: Anand'),
                        SizedBox(width: 8),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'View On Maps',
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Divider(color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'About The Event',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'The Comedy Factory brings to you TCF Line ups, a show where three comedians from Gujarat, Om Bhatt, Harshil Pandya and Jeel Aagja bring to you their hilarious set of jokes, stories and more.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Requirements',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showRequirements(context),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: primaryColor),
                            SizedBox(width: 8),
                            Text('Click to see requirements'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Artist',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          color: accentColor3,
                        ),
                        SizedBox(width: 8),
                        Text('Om Bhatt\nActor'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showTermsAndConditions(context),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: primaryColor),
                            SizedBox(width: 8),
                            Text('Click to see terms and conditions'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Tags/Keywords',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '#Comedy #LiveShow #Gujarat #Entertainment',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Organizer Contact Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Email: organizer@example.com\nPhone: +91 98765 43210',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Event Highlights',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. Live comedy performances by top comedians.\n2. Interactive sessions with the performers.\n3. Delicious food and beverages.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'FAQs',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Q: What time should I arrive?\nA: Please arrive at least 30 minutes before the event starts.\n\nQ: Are there any age restrictions?\nA: Yes, the event is restricted to individuals 18 years and older.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Accessibility Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'The venue is wheelchair accessible and provides assistance for guests with special needs.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Connect with Us',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.facebook, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Facebook'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.photo, color: Colors.purple), // Placeholder for Instagram
                        SizedBox(width: 8),
                        Text('Instagram'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Divider(color: Colors.grey),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
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
                              MaterialPageRoute(builder: (context) => BookingPage()),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(primaryColor),
                            overlayColor: MaterialStateProperty.all(accentColor),
                          ),
                          child: Text('Register Now', style: TextStyle(color: secondaryColor)),
                        ),
                      ],
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
