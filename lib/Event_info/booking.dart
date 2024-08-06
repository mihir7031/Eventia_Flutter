import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int totalTickets = 0;
  double totalPrice = 0.0;

  final List<TicketCategory> categories = [
    TicketCategory(name: 'GA - PHASE 1', price: 999),
    TicketCategory(name: 'FANZONE - PHASE 1', price: 1699),
    TicketCategory(name: 'GA - COUPLE PASS', price: 1699),
    TicketCategory(name: 'FANZONE - COUPLE PASS', price: 2999),
  ];

  void addTicket(int index) {
    setState(() {
      categories[index].quantity++;
      totalTickets++;
      totalPrice += categories[index].price;
    });
  }

  void removeTicket(int index) {
    setState(() {
      if (categories[index].quantity > 0) {
        categories[index].quantity--;
        totalTickets--;
        totalPrice -= categories[index].price;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prateek Kuhad Silhouettes Tour'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              // Handle help or info action
            },
            tooltip: 'Help',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Sun 22 Dec at 6:00 PM | Savanna Party Lawn',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Your Ticket Category',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length + 1, // +1 for the summary card
              itemBuilder: (context, index) {
                if (index == categories.length) {
                  // Simple text card for the summary
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Price: ₹${totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '$totalTickets Tickets',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: totalTickets > 0 ? () {
                            // Handle booking action
                          } : null,
                          child: Text('Proceed'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  final category = categories[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    elevation: 4.0,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(
                        category.name,
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('₹${category.price.toStringAsFixed(2)}'),
                      trailing: category.quantity == 0
                          ? ElevatedButton(
                        onPressed: () => addTicket(index),
                        child: Text('Add'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      )
                          : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => removeTicket(index),
                          ),
                          Text('${category.quantity}'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => addTicket(index),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.deepPurple,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}

class TicketCategory {
  final String name;
  final double price;
  int quantity;

  TicketCategory({
    required this.name,
    required this.price,
    this.quantity = 0,
  });
}
