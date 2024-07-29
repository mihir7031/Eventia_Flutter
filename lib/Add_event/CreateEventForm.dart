import 'package:flutter/material.dart';

class CreateEventForm extends StatefulWidget {
  const CreateEventForm({super.key});

  @override
  State<CreateEventForm> createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isOffline = true;
  bool _showSponsor = false;
  bool _showAgenda = false;
  bool _showMedia = false;
  bool _showVolunteer = false;
  bool _showMoreFeatures = false;
  bool _isPaid = false;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = '';
    _timeController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Event Information
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Event Information',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Event Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter event name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Event Mode'),
                        items: [
                          DropdownMenuItem(
                              value: 'Offline', child: Text('Offline')),
                          DropdownMenuItem(
                              value: 'Online', child: Text('Online')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _isOffline = value == 'Offline';
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select event mode';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      if (_isOffline)
                        Column(
                          children: [
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Location'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter location';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(labelText: 'Date'),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null &&
                              pickedDate != _selectedDate) {
                            setState(() {
                              _selectedDate = pickedDate;
                              _dateController.text =
                                  "${_selectedDate!.toLocal()}".split(' ')[0];
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter date';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _timeController,
                        decoration: InputDecoration(labelText: 'Time'),
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null &&
                              pickedTime != _selectedTime) {
                            setState(() {
                              _selectedTime = pickedTime;
                              _timeController.text =
                                  "${_selectedTime!.format(context)}";
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter time';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Duration (hours)'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter duration';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'About Event'),
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter event description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Organization Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter organization name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Event Website (Optional)'),
                        keyboardType: TextInputType.url,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Capacity'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter event capacity';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              title: Text('Paid'),
                              value: true,
                              groupValue: _isPaid,
                              onChanged: (value) {
                                setState(() {
                                  _isPaid = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: Text('Unpaid'),
                              value: false,
                              groupValue: _isPaid,
                              onChanged: (value) {
                                setState(() {
                                  _isPaid = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      if (_isPaid)
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number,
                        ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Registration Deadline'),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null &&
                              pickedDate != _selectedDate) {
                            setState(() {
                              _selectedDate = pickedDate;
                              _dateController.text =
                                  "${_selectedDate!.toLocal()}".split(' ')[0];
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter registration deadline';
                          }
                          return null;
                        },
                      ),
                      // Adding New Field
                      SizedBox(height: 16),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Contact Person'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter contact person';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showMoreFeatures = !_showMoreFeatures;
                          });
                        },
                        child: Text(_showMoreFeatures
                            ? 'Hide More Features'
                            : 'Show More Features'),
                      ),
                    ],
                  ),
                ),
                if (_showMoreFeatures)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.greenAccent),
                    ),
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Additional Features',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        CheckboxListTile(
                          title: Text('Include Sponsors'),
                          value: _showSponsor,
                          onChanged: (bool? value) {
                            setState(() {
                              _showSponsor = value!;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Include Agenda'),
                          value: _showAgenda,
                          onChanged: (bool? value) {
                            setState(() {
                              _showAgenda = value!;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Include Media (Video/Images)'),
                          value: _showMedia,
                          onChanged: (bool? value) {
                            setState(() {
                              _showMedia = value!;
                            });
                          },
                        ),
                        if (_showMedia)
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Media URL'),
                            keyboardType: TextInputType.url,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                RegExp urlPattern = RegExp(
                                  r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$',
                                  caseSensitive: false,
                                  multiLine: false,
                                );
                                if (!urlPattern.hasMatch(value)) {
                                  return 'Please enter a valid URL';
                                }
                              }
                              return null;
                            },
                          ),
                        CheckboxListTile(
                          title: Text('Include Volunteers'),
                          value: _showVolunteer,
                          onChanged: (bool? value) {
                            setState(() {
                              _showVolunteer = value!;
                            });
                          },
                        ),
                        if (_showVolunteer)
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Maximum Volunteers'),
                            keyboardType: TextInputType.number,
                          ),
                      ],
                    ),
                  ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process data.
                    }
                  },
                  child: Text('Create Event'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
