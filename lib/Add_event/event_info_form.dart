import 'package:flutter/material.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  bool isOffline = false; // To track the event mode (Online/Offline)
  bool isPaid = false;    // To track the event type (Paid/Unpaid)

  List<TicketType> ticketTypes = []; // List to store multiple ticket types
  List<CustomField> customFields = []; // List to store custom fields (text/photo)
  List<ConfirmedField> confirmedFields = []; // List to store confirmed fields

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // AppBar color
        title: const Text('Create New Event', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.white, // White background for the page
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Event Name', 'Enter the name of the event'),
              _buildDateTimePicker(context, 'Event Date', 'Select Date'),
              _buildDateTimePicker(context, 'Event Time', 'Select Time'),
              _buildTextField('Duration', 'Enter duration (e.g., 2 hours)'),
              _buildTextField('Capacity', 'Enter max number of attendees'),
              _buildEventModeSelector(), // Toggle button for event mode
              if (isOffline) _buildTextField('Location', 'Enter event location'), // Show location field if offline
              _buildEventTypeSelector(), // Toggle button for event type
              if (isPaid) _buildPaidEventFields(), // Show extra fields if paid event
              _buildAgeLimit(),
              _buildImagePicker(),
              _buildDescriptionField(),
              const SizedBox(height: 20),
              ..._buildConfirmedFields(), // Display confirmed fields
              ..._buildCustomFields(), // Display dynamic custom fields
              _buildAddFieldButton(),  // Button to add more custom fields
              const SizedBox(height: 20),
              _buildSaveButton(context),
              _buildCancelButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build a generic text field
  Widget _buildTextField(String label, String placeholder) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: placeholder,
              fillColor: Colors.lightBlue[100], // Light blue background
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to build date and time pickers
  Widget _buildDateTimePicker(BuildContext context, String label, String placeholder) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: placeholder,
              fillColor: Colors.lightBlue[100], // Light blue background
              filled: true,
              suffixIcon: const Icon(Icons.calendar_today, color: Colors.blue), // Blue icon
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                // Handle the selected date
              }
            },
          ),
        ],
      ),
    );
  }

  // Method to build event mode toggle button (Online/Offline)
  Widget _buildEventModeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SwitchListTile(
        title: const Text('Event Mode', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(isOffline ? 'Offline' : 'Online'),
        activeColor: Colors.blue,
        value: isOffline,
        onChanged: (bool value) {
          setState(() {
            isOffline = value; // Toggle the mode
          });
        },
      ),
    );
  }

  // Method to build event type toggle button (Paid/Unpaid)
  Widget _buildEventTypeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SwitchListTile(
        title: const Text('Event Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(isPaid ? 'Paid' : 'Unpaid'),
        activeColor: Colors.blue,
        value: isPaid,
        onChanged: (bool value) {
          setState(() {
            isPaid = value; // Toggle the event type
          });
        },
      ),
    );
  }

  // Method to build additional fields if the event is "Paid"
  Widget _buildPaidEventFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          "Ticket Types",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ticketTypes.length,
          itemBuilder: (context, index) {
            return _buildTicketTypeFields(index);
          },
        ),
        const SizedBox(height: 10),
        _buildAddTicketButton(), // Button to add more ticket types
      ],
    );
  }

  // Method to build the individual ticket type fields
  Widget _buildTicketTypeFields(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField('Ticket Type', 'Enter ticket type (e.g., VIP, Regular)'),
          _buildTextField('Ticket Price', 'Enter price per ticket'),
          _buildTextField('Max Tickets', 'Enter maximum tickets available'),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    ticketTypes.removeAt(index); // Remove the selected ticket type
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red, // Red background color
                ),
                child: const Text('Remove', style: TextStyle(color: Colors.white)), // White text color
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Method to build the button to add more ticket types
  Widget _buildAddTicketButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Blue button background
      ),
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text('Add Ticket Type', style: TextStyle(color: Colors.white)),
      onPressed: () {
        setState(() {
          ticketTypes.add(TicketType()); // Add a new ticket type
        });
      },
    );
  }

  // Method to build age limit input
  Widget _buildAgeLimit() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Age Limit (optional)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter age limit',
              fillColor: Colors.lightBlue[100], // Light blue background
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to build image picker input
  Widget _buildImagePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Event Poster (optional)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Blue button background
            ),
            icon: const Icon(Icons.photo, color: Colors.white),
            label: const Text('Choose Photo', style: TextStyle(color: Colors.white)),
            onPressed: () {
              // Handle image picking
            },
          ),
        ],
      ),
    );
  }

  // Method to build brief information input
  Widget _buildDescriptionField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Brief Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Enter brief information about the event',
              fillColor: Colors.lightBlue[100], // Light blue background
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to dynamically build confirmed fields
  List<Widget> _buildConfirmedFields() {
    return confirmedFields.map((field) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(field.fieldName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            if (field is ConfirmedTextField) ...[
              const SizedBox(height: 8),
              Text(field.value ?? "", style: const TextStyle(fontSize: 14)),
            ] else if (field is ConfirmedPhotoField) ...[
              const SizedBox(height: 8),
              const Icon(Icons.photo), // Placeholder for photo preview
            ],
          ],
        ),
      );
    }).toList();
  }

  // Method to dynamically build custom fields (editable)
  List<Widget> _buildCustomFields() {
    return customFields.map((field) {
      return field.build(context, () {
        setState(() {
          customFields.remove(field); // Remove the selected custom field
        });
      }, (confirmedField) {
        setState(() {
          confirmedFields.add(confirmedField); // Add the confirmed field to the list
          customFields.remove(field); // Remove the editable field
        });
      });
    }).toList();
  }

  // Method to build the "Add Field" button
  Widget _buildAddFieldButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Blue button background
      ),
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text('Add Field', style: TextStyle(color: Colors.white)),
      onPressed: () {
        _showAddFieldDialog();
      },
    );
  }

  // Dialog to show options for adding custom fields
  void _showAddFieldDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Field'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Add Text Field'),
                onTap: () {
                  setState(() {
                    customFields.add(TextFieldCustom()); // Add text field
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Add Photo Field'),
                onTap: () {
                  setState(() {
                    customFields.add(PhotoFieldCustom()); // Add photo field
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Method to build Save button
  Widget _buildSaveButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Blue button background
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
        ),
        onPressed: () {
          // Handle save action
        },
        child: const Text('Save Event', style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  // Method to build Cancel button
  Widget _buildCancelButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey, // Grey button background
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
        ),
        onPressed: () {
          Navigator.pop(context); // Go back to previous page
        },
        child: const Text('Cancel', style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}

// Class to hold Ticket Type details
class TicketType {
  String type = '';
  double price = 0.0;
  int maxTickets = 0;
}

// Abstract class for confirmed fields
abstract class ConfirmedField {
  String fieldName;
  ConfirmedField(this.fieldName);
}

// Confirmed text field
class ConfirmedTextField extends ConfirmedField {
  String? value;
  ConfirmedTextField(String fieldName, this.value) : super(fieldName);
}

// Confirmed photo field
class ConfirmedPhotoField extends ConfirmedField {
  ConfirmedPhotoField(String fieldName) : super(fieldName);
}

// Custom field abstract class
abstract class CustomField {
  Widget build(BuildContext context, VoidCallback onRemove, Function(ConfirmedField) onConfirm);
}

// Custom text field with editable title
class TextFieldCustom extends CustomField {
  String fieldName = 'Custom Text Field'; // Default name of the field
  String? fieldValue;

  @override
  Widget build(BuildContext context, VoidCallback onRemove, Function(ConfirmedField) onConfirm) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomFieldHeader(onRemove, onConfirm),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter text',
              fillColor: Colors.lightBlue[100],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              fieldValue = value; // Capture field value
            },
          ),
        ],
      ),
    );
  }

  // Header that includes an editable field name and remove/confirm buttons
  Widget _buildCustomFieldHeader(VoidCallback onRemove, Function(ConfirmedField) onConfirm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: TextField(
            onChanged: (value) {
              fieldName = value; // Update field name
            },
            decoration: InputDecoration(
              hintText: fieldName,
              fillColor: Colors.lightBlue[100],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.check, color: Colors.green), // Green check icon
          onPressed: () {
            onConfirm(ConfirmedTextField(fieldName, fieldValue)); // Confirm the field
          },
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.red), // Red remove icon
          onPressed: onRemove, // Remove the field
        ),
      ],
    );
  }
}

// Custom photo field with editable title
class PhotoFieldCustom extends CustomField {
  String fieldName = 'Custom Photo Field'; // Default name of the field

  @override
  Widget build(BuildContext context, VoidCallback onRemove, Function(ConfirmedField) onConfirm) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomFieldHeader(onRemove, onConfirm),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            icon: const Icon(Icons.photo, color: Colors.white),
            label: const Text('Choose Photo', style: TextStyle(color: Colors.white)),
            onPressed: () {
              // Handle image picking
            },
          ),
        ],
      ),
    );
  }

  // Header that includes an editable field name and remove/confirm buttons
  Widget _buildCustomFieldHeader(VoidCallback onRemove, Function(ConfirmedField) onConfirm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: TextField(
            onChanged: (value) {
              fieldName = value; // Update field name
            },
            decoration: InputDecoration(
              hintText: fieldName,
              fillColor: Colors.lightBlue[100],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.check, color: Colors.green), // Green check icon
          onPressed: () {
            onConfirm(ConfirmedPhotoField(fieldName)); // Confirm the photo field
          },
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.red), // Red remove icon
          onPressed: onRemove, // Remove the field
        ),
      ],
    );
  }
}