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
              ..._buildCustomFields(), // Dynamically added custom fields
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

  // Method to build image picker
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

  // Method to dynamically build custom fields
  List<Widget> _buildCustomFields() {
    return customFields.map((field) {
      return field.build(context, () {
        setState(() {
          customFields.remove(field); // Remove the selected custom field
        });
      }, () {
        setState(() {}); // Update state after editing
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
              ListTile(
                title: const Text('Add File Field'),
                onTap: () {
                  setState(() {
                    customFields.add(FileFieldCustom()); // Add file field
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Add Social Media Field'),
                onTap: () {
                  setState(() {
                    customFields.add(SocialMediaFieldCustom()); // Add social media field
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Add Link Field'),
                onTap: () {
                  setState(() {
                    customFields.add(LinkFieldCustom()); // Add link field
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Add Number Field'),
                onTap: () {
                  setState(() {
                    customFields.add(NumberFieldCustom()); // Add number field
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

// Custom field abstract class
abstract class CustomField {
  Widget build(BuildContext context, VoidCallback onRemove, VoidCallback onEdit);
}

// Custom text field with editable title and edit functionality
class TextFieldCustom extends CustomField {
  String fieldName = 'Custom Text Field'; // Default name of the field
  String fieldValue = ''; // Value of the text entered
  bool isEditing = false; // To track edit mode

  @override
  Widget build(BuildContext context, VoidCallback onRemove, VoidCallback onEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomFieldHeader(onRemove, onEdit),
          TextField(
            enabled: isEditing, // Enable text field in edit mode
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
              fieldValue = value; // Store the field value
            },
          ),
        ],
      ),
    );
  }

  // Header that includes an editable field name, edit button, and remove button
  Widget _buildCustomFieldHeader(VoidCallback onRemove, VoidCallback onEdit) {
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
        TextButton(
          onPressed: () {
            isEditing = !isEditing; // Toggle editing mode
            onEdit(); // Notify parent widget to refresh the UI
          },
          style: TextButton.styleFrom(
            backgroundColor: isEditing ? Colors.green : Colors.blue, // Toggle button color
          ),
          child: Text(isEditing ? 'Save' : 'Edit', style: const TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: onRemove,
          style: TextButton.styleFrom(
            backgroundColor: Colors.red, // Red background color
          ),
          child: const Text('Remove', style: TextStyle(color: Colors.white)), // White text color
        ),
      ],
    );
  }
}

// Custom photo field with editable title and edit functionality
class PhotoFieldCustom extends CustomField {
  String fieldName = 'Custom Photo Field'; // Default name of the field
  bool isEditing = false; // To track edit mode

  @override
  Widget build(BuildContext context, VoidCallback onRemove, VoidCallback onEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomFieldHeader(onRemove, onEdit),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            icon: const Icon(Icons.photo, color: Colors.white),
            label: const Text('Choose Photo', style: TextStyle(color: Colors.white)),
            onPressed: isEditing
                ? () {
              // Handle image picking
            }
                : null, // Disable button if not in edit mode
          ),
        ],
      ),
    );
  }

  // Header that includes an editable field name, edit button, and remove button
  Widget _buildCustomFieldHeader(VoidCallback onRemove, VoidCallback onEdit) {
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
        TextButton(
          onPressed: () {
            isEditing = !isEditing; // Toggle editing mode
            onEdit(); // Notify parent widget to refresh the UI
          },
          style: TextButton.styleFrom(
            backgroundColor: isEditing ? Colors.green : Colors.blue, // Toggle button color
          ),
          child: Text(isEditing ? 'Save' : 'Edit', style: const TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: onRemove,
          style: TextButton.styleFrom(
            backgroundColor: Colors.red, // Red background color
          ),
          child: const Text('Remove', style: TextStyle(color: Colors.white)), // White text color
        ),
      ],
    );
  }
}

// Custom field for files
class FileFieldCustom extends CustomField {
  String fieldName = 'Custom File Field';
  bool isEditing = false;

  @override
  Widget build(BuildContext context, VoidCallback onRemove, VoidCallback onEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomFieldHeader(onRemove, onEdit),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            icon: const Icon(Icons.attach_file, color: Colors.white),
            label: const Text('Choose File', style: TextStyle(color: Colors.white)),
            onPressed: isEditing
                ? () {
              // Handle file picking
            }
                : null, // Disable button if not in edit mode
          ),
        ],
      ),
    );
  }

  Widget _buildCustomFieldHeader(VoidCallback onRemove, VoidCallback onEdit) {
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
        TextButton(
          onPressed: () {
            isEditing = !isEditing; // Toggle editing mode
            onEdit(); // Notify parent widget to refresh the UI
          },
          style: TextButton.styleFrom(
            backgroundColor: isEditing ? Colors.green : Colors.blue, // Toggle button color
          ),
          child: Text(isEditing ? 'Save' : 'Edit', style: const TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: onRemove,
          style: TextButton.styleFrom(
            backgroundColor: Colors.red, // Red background color
          ),
          child: const Text('Remove', style: TextStyle(color: Colors.white)), // White text color
        ),
      ],
    );
  }
}

// Custom field for social media links
class SocialMediaFieldCustom extends CustomField {
  String fieldName = 'Custom Social Media Field';
  String link = '';
  bool isEditing = false;

  @override
  Widget build(BuildContext context, VoidCallback onRemove, VoidCallback onEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomFieldHeader(onRemove, onEdit),
          TextField(
            enabled: isEditing, // Enable text field in edit mode
            decoration: InputDecoration(
              hintText: 'Enter social media link',
              fillColor: Colors.lightBlue[100],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              link = value; // Store the link
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomFieldHeader(VoidCallback onRemove, VoidCallback onEdit) {
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
        TextButton(
          onPressed: () {
            isEditing = !isEditing; // Toggle editing mode
            onEdit(); // Notify parent widget to refresh the UI
          },
          style: TextButton.styleFrom(
            backgroundColor: isEditing ? Colors.green : Colors.blue, // Toggle button color
          ),
          child: Text(isEditing ? 'Save' : 'Edit', style: const TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: onRemove,
          style: TextButton.styleFrom(
            backgroundColor: Colors.red, // Red background color
          ),
          child: const Text('Remove', style: TextStyle(color: Colors.white)), // White text color
        ),
      ],
    );
  }
}

// Custom field for links
class LinkFieldCustom extends CustomField {
  String fieldName = 'Custom Link Field';
  String link = '';
  bool isEditing = false;

  @override
  Widget build(BuildContext context, VoidCallback onRemove, VoidCallback onEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomFieldHeader(onRemove, onEdit),
          TextField(
            enabled: isEditing, // Enable text field in edit mode
            decoration: InputDecoration(
              hintText: 'Enter link',
              fillColor: Colors.lightBlue[100],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              link = value; // Store the link
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomFieldHeader(VoidCallback onRemove, VoidCallback onEdit) {
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
        TextButton(
          onPressed: () {
            isEditing = !isEditing; // Toggle editing mode
            onEdit(); // Notify parent widget to refresh the UI
          },
          style: TextButton.styleFrom(
            backgroundColor: isEditing ? Colors.green : Colors.blue, // Toggle button color
          ),
          child: Text(isEditing ? 'Save' : 'Edit', style: const TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: onRemove,
          style: TextButton.styleFrom(
            backgroundColor: Colors.red, // Red background color
          ),
          child: const Text('Remove', style: TextStyle(color: Colors.white)), // White text color
        ),
      ],
    );
  }
}

// Custom field for numbers
class NumberFieldCustom extends CustomField {
  String fieldName = 'Custom Number Field';
  String value = '';
  bool isEditing = false;

  @override
  Widget build(BuildContext context, VoidCallback onRemove, VoidCallback onEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomFieldHeader(onRemove, onEdit),
          TextField(
            keyboardType: TextInputType.number,
            enabled: isEditing, // Enable text field in edit mode
            decoration: InputDecoration(
              hintText: 'Enter number',
              fillColor: Colors.lightBlue[100],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              this.value = value; // Store the number value
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomFieldHeader(VoidCallback onRemove, VoidCallback onEdit) {
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
        TextButton(
          onPressed: () {
            isEditing = !isEditing; // Toggle editing mode
            onEdit(); // Notify parent widget to refresh the UI
          },
          style: TextButton.styleFrom(
            backgroundColor: isEditing ? Colors.green : Colors.blue, // Toggle button color
          ),
          child: Text(isEditing ? 'Save' : 'Edit', style: const TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: onRemove,
          style: TextButton.styleFrom(
            backgroundColor: Colors.purple, // Red background color
          ),
          child: const Text('Remove', style: TextStyle(color: Colors.white)), // White text color
        ),
      ],
    );
  }
}