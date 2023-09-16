  import 'package:adopt_v2/src/features/reminders/repositories/reminder_repository.dart';
  import 'package:adopt_v2/src/features/reminders/widgets/reminder_list.dart';
  import 'package:flutter/material.dart';


  class AddReminderScreen extends StatefulWidget {
    @override
    _AddReminderScreenState createState() => _AddReminderScreenState();
  }

  class _AddReminderScreenState extends State<AddReminderScreen> {
    String? selectedFrequency;
    String? selectedType;
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    TextEditingController _titleTextController = TextEditingController();
    TextEditingController _nameTextController = TextEditingController();
    TextEditingController _descTextController = TextEditingController();

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)),
      );

      if (pickedDate != null && pickedDate != selectedDate) {
        setState(() {
          selectedDate = pickedDate;
        });
      }
    }


    Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null && pickedTime != selectedTime) {
        setState(() {
          selectedTime = pickedTime;
        });
      }
    }

    void _saveReminders() async {
      final String titleText = _titleTextController.text;
      final String nameText = _nameTextController.text;
      final String descText = _descTextController.text;

      final String user = 'Logged User'; // Replace with the logged-in user details
      final DateTime now = DateTime.now();

      final ReminderRepository repository = ReminderRepository();
      await repository.addReminder(titleText, nameText, selectedType, selectedFrequency, selectedDate, selectedTime, user, now);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Reminder added successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ReminderListScreen()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Add Reminder'),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleTextController,
                  decoration: InputDecoration(
                    labelText: 'Reminder Title',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _nameTextController,
                  decoration: InputDecoration(
                    labelText: 'Pet Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  items: [
                    DropdownMenuItem(child: Text('feeding'), value: 'feeding'),
                    DropdownMenuItem(child: Text('medication'), value: 'medication'),
                    DropdownMenuItem(child: Text('grooming'), value: 'grooming'),
                    DropdownMenuItem(child: Text('veterinary appointment'), value: 'veterinary appointment'),
                    DropdownMenuItem(child: Text('exercise'), value: 'exercise'),
                  ],
                  value: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Reminder Type',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  items: [
                    DropdownMenuItem(child: Text('One-time'), value: 'one_time'),
                    DropdownMenuItem(child: Text('Daily'), value: 'daily'),
                    DropdownMenuItem(child: Text('Weekly'), value: 'weekly'),
                    DropdownMenuItem(child: Text('Monthly'), value: 'monthly'),
                  ],
                  value: selectedFrequency,
                  onChanged: (value) {
                    setState(() {
                      selectedFrequency = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Frequency',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Date: ${selectedDate?.toString() ?? 'Not set'}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                OutlinedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date'),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Time: ${selectedTime?.format(context) ?? 'Not set'}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                OutlinedButton(
                  onPressed: () => _selectTime(context),
                  child: Text('Select Time'),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _descTextController,
                  decoration: InputDecoration(
                    labelText: 'Description/Instructions',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                // Add other input fields and widgets as necessary
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _saveReminders();
            // Handle save or submit action
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }
