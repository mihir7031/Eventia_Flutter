import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> _notifications = [
    {
      'icon': Icons.event,
      'title': 'Event Starting Soon',
      'message': 'The event you registered for is starting in 30 minutes.',
      'timestamp': '2024-08-23 14:45',
      'color': Colors.pinkAccent,
      'details': 'The event will take place at the main auditorium. Please ensure you arrive 15 minutes early for check-in.',
    },

    {
      'icon': Icons.check_circle,
      'title': 'Registration Completed',
      'message': 'You have successfully registered for the event.',
      'timestamp': '2024-08-22 10:00',
      'color': Colors.green,
      'details': 'Thank you for registering! Check your email for the event details and ticket.',
    },

    {
      'icon': Icons.info,
      'title': 'Important Update',
      'message': 'There has been an update to the event schedule.',
      'timestamp': '2024-08-21 18:30',
      'color': Colors.blue,
      'details': 'The event schedule has been updated. Please visit our website for the latest information.',
    },
    {
      'icon': Icons.warning,
      'title': 'Alert',
      'message': 'The event has been rescheduled. Please check the new date.',
      'timestamp': '2024-08-20 08:15',
      'color': Colors.red,
      'details': 'The event has been rescheduled to next month. Please check your email for the new date and time.',
    },

    {
      'icon': Icons.notifications_active,
      'title': 'New Feature Released',
      'message': 'We have released a new feature to enhance your event experience.',
      'timestamp': '2024-08-19 16:00',
      'color': Colors.deepPurple,
      'details': 'Check out the new features on our app and let us know what you think!',
    },
    {
      'icon': Icons.star,
      'title': 'Special Offer',
      'message': 'Exclusive offer for our users! Get 20% off on all event tickets.',
      'timestamp': '2024-08-17 09:30',
      'color': Colors.teal,
      'details': 'Use code SPECIAL20 at checkout to redeem your discount. Offer valid until the end of the month.',
    },
    {
      'icon': Icons.campaign,
      'title': 'Campaign Update',
      'message': 'The campaign you participated in has new updates.',
      'timestamp': '2024-08-16 15:45',
      'color': Colors.redAccent,
      'details': 'Check out the latest updates and progress of the campaign on our website.',
    },

    {
      'icon': Icons.help_outline,
      'title': 'Support Request',
      'message': 'Your support request has been received and is being reviewed.',
      'timestamp': '2024-08-15 13:00',
      'color': Colors.blueAccent,
      'details': 'Our support team will get back to you within 24 hours. Thank you for your patience.',
    },
    // New notification
    {
      'icon': Icons.local_offer,
      'title': 'Exclusive Invitation',
      'message': 'You are invited to an exclusive event for premium users.',
      'timestamp': '2024-08-14 11:30',
      'color': Colors.purple,
      'details': 'As a valued premium user, you are invited to an exclusive event. Check your email for more details and RSVP.',
    },
  ];

  Map<String, dynamic>? _lastRemovedNotification;
  int? _lastRemovedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EEEA), // Primary background color
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView.builder(
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            final notification = _notifications[index];
            return _buildNotificationCard(
              context,
              icon: notification['icon'],
              title: notification['title'],
              message: notification['message'],
              timestamp: notification['timestamp'],
              color: notification['color'],
              details: notification['details'],
              index: index,
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String message,
        required String timestamp,
        required Color color,
        required String details,
        required int index,
      }) {
    return Dismissible(
      key: UniqueKey(), // Unique key for the Dismissible widget
      background: Container(
        color: Colors.red, // Background color for swipe-to-dismiss
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // Save the removed notification
        setState(() {
          _lastRemovedNotification = _notifications[index];
          _lastRemovedIndex = index;
          _notifications.removeAt(index);
        });

        // Show a SnackBar with an Undo option
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title dismissed'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Undo the dismissal
                setState(() {
                  if (_lastRemovedNotification != null && _lastRemovedIndex != null) {
                    _notifications.insert(_lastRemovedIndex!, _lastRemovedNotification!);
                    _lastRemovedNotification = null;
                    _lastRemovedIndex = null;
                  }
                });
              },
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: color,
            size: 40.0,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                timestamp,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 14.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.all(16.0),
          onTap: () {
            _showNotificationDetails(context, title, details);
          },
        ),
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, String title, String details) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(details),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
