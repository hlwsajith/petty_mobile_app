import 'package:adopt_v2/src/core/widgets/message_dialog.dart';
import 'package:adopt_v2/src/features/profilepage/widgets/appointment_list.dart';
import 'package:adopt_v2/src/features/shoppage/models/VetsService.dart';
import 'package:adopt_v2/src/features/vetScreens/models/Appointment.dart';
import 'package:adopt_v2/src/features/vetScreens/repositories/vet_repository.dart';
import 'package:adopt_v2/src/features/vetScreens/screens/appointments_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class AddService extends StatefulWidget {
  final String vetname;

  AddService({required this.vetname});
  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  String username = '';
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _initializeData().then((_) {
    _veterincategoryController.text = widget.vetname;
    _vaccinationController.text = vaccination;
    _appointmentTypeController.text = appointmentType;
    _petSpeciesController.text = petSpecies;
    _petBreedController.text = petBreed;
    String formattedDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(appointmentDateTime);
    dateTimeController.text = formattedDateTime;
    });
  }

  Future<void> _initializeData() async {
    username = await storage.read(key: 'username') ?? '';
    setState(() {
      username = username;
    });
  }

  final VetRepository _appointmentRepository = VetRepository();
  // Define variables to hold the form data
  String petName = '';
  String veterinarianName = 'Vet1';
  DateTime appointmentDateTime = DateTime.now();

  String appointmentType = 'General Checkup';
  String reasonForAppointment = '';
  String ownerName = '';
  String ownerPhoneNumber = '';
  String ownerEmailAddress = '';
  String petSpecies = 'Dog';
  String petBreed = 'Breed1';
  int petAge = 0;
  String vaccination = 'Vaccinated';
  String medicalHistory = '';
  String additionalNotes = '';

  TextEditingController _veterincategoryController = TextEditingController();
  TextEditingController _appointmentTypeController = TextEditingController();
  TextEditingController _petSpeciesController = TextEditingController();
  TextEditingController _petBreedController = TextEditingController();
  TextEditingController _petNameController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();
  TextEditingController _ownerNameController = TextEditingController();
  TextEditingController _ownerPhoneController = TextEditingController();
  TextEditingController _ownerEmailController = TextEditingController();
  TextEditingController _petAgeController = TextEditingController();
  TextEditingController _vaccinationController = TextEditingController();
  TextEditingController _medicalHistoryController = TextEditingController();
  TextEditingController _additionalNotesController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  // Initialize with the current date and time


  // Define lists for dropdown options
  List<String> appointmentTypes = [
    'General Checkup',
    'Vaccination',
    'Surgery',
    'Dental Cleaning',
    'Consultation',
    'Follow-up',
    'Other'
  ];

  List<String> _veterincategories = ['Vet1', 'Vet2', 'Vet3', 'Vet4'];

  List<String> petSpeciesOptions = [
    'Dog',
    'Cat',
    'Bird',
    'Rabbit',
    'Reptile',
    'Other'
  ];

  List<String> petBreedOptions = ['Breed1', 'Breed2', 'Breed3', 'Other'];

  List<String> vaccinationRecords = ['Vaccinated', 'Not Vaccinated'];

  // Form submission function (you can implement this)
  // void submitForm() async {
  //   // Implement form submission logic here
  //   // You can send the form data to an API or perform other actions
  //   // Reset the form after submission if needed
  //   Appointment appointmentData = Appointment(
  //       appointmentId: '',
  //       petName: _petNameController.text.trim(),
  //       veterinarianName: _veterincategoryController.text.trim(),
  //       appointmentDateTime: DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateTimeController.text.trim()),
  //       appointmentType: _appointmentTypeController.text.trim(),
  //       reasonForAppointment: _reasonController.text.trim(),
  //       ownerName: _ownerNameController.text.trim(),
  //       ownerPhoneNumber: _ownerPhoneController.text.trim(),
  //       ownerEmailAddress: _ownerEmailController.text.trim(),
  //       petSpecies: _petSpeciesController.text.trim(),
  //       petBreed: _petBreedController.text.trim(),
  //       petAge: int.parse(_petAgeController.text.trim()),
  //       vaccinationRecords: _vaccinationController.text.trim(),
  //       medicalHistory: _medicalHistoryController.text.trim(),
  //       additionalNotes: _additionalNotesController.text.trim(),
  //       appointmentStatus: 'Incoming'
  //   );
  //   int? responseCode = await _appointmentRepository.saveAppointment(appointmentData);
  //   if (responseCode == 201) {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return MessageDialog(
  //           title: 'Successful',
  //           content: 'Appointment Added Successful',
  //           icon: Icons.check_circle,
  //           iconColor: Colors.green,
  //           buttonColor: Colors.green,
  //           buttonText: 'OK',
  //           onButtonPressed: () {
  //             Navigator.of(context).pop(); // Close the dialog
  //             _clearForm();
  //             routePage();// Clear input fields and selected image
  //           },
  //         );
  //       },
  //     );
  //
  //   } else {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return MessageDialog(
  //           title: 'Unsuccessful',
  //           content: 'Appointment Add Unsuccessful',
  //           icon: Icons.error,
  //           iconColor: Colors.red,
  //           buttonColor: Colors.red,
  //           buttonText: 'OK',
  //           onButtonPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //         );
  //       },
  //     );
  //   }
  // }

  void submitForm() async {
    try {
      final appointmentData = Appointment(
        appointmentId: '',
        petName: _petNameController.text.trim(),
        veterinarianName: _veterincategoryController.text.trim(),
        appointmentDateTime: dateTimeController.text.trim(), // Use the parsed date and time here
        appointmentType: _appointmentTypeController.text.trim(),
        reasonForAppointment: _reasonController.text.trim(),
        ownerName: username,
        ownerPhoneNumber: _ownerPhoneController.text.trim(),
        ownerEmailAddress: _ownerEmailController.text.trim(),
        petSpecies: _petSpeciesController.text.trim(),
        petBreed: _petBreedController.text.trim(),
        petAge: int.parse(_petAgeController.text.trim()),
        vaccinationRecords: _vaccinationController.text.trim(),
        medicalHistory: _medicalHistoryController.text.trim(),
        additionalNotes: _additionalNotesController.text.trim(),
        appointmentStatus: 'Incoming',
      );
      int? responseCode = await _appointmentRepository.saveAppointment(appointmentData);
      if (responseCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MessageDialog(
              title: 'Successful',
              content: 'Appointment Added Successful',
              icon: Icons.check_circle,
              iconColor: Colors.green,
              buttonColor: Colors.green,
              buttonText: 'OK',
              onButtonPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _clearForm();
                routePage(); // Clear input fields and selected image
              },
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MessageDialog(
              title: 'Unsuccessful',
              content: 'Appointment Add Unsuccessful',
              icon: Icons.error,
              iconColor: Colors.red,
              buttonColor: Colors.red,
              buttonText: 'OK',
              onButtonPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
    } catch (e) {
      print("Error parsing date and time: $e");
      // Handle the parsing error, e.g., show an error message to the user
    }
  }

  DateTime parseDateTime(String inputDate) {
    final RegExp regExp =
    RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$'); // Regex for the format "yyyy-MM-dd HH:mm:ss"
    if (!regExp.hasMatch(inputDate)) {
      throw FormatException('Invalid date and time format');
    }

    final List<String> dateTimeParts = inputDate.split(' ');
    final List<String> dateParts = dateTimeParts[0].split('-');
    final List<String> timeParts = dateTimeParts[1].split(':');

    final DateTime parsedDateTime = DateTime(
      int.parse(dateParts[0]), // year
      int.parse(dateParts[1]), // month
      int.parse(dateParts[2]), // day
      int.parse(timeParts[0]), // hour
      int.parse(timeParts[1]), // minute
      int.parse(timeParts[2]), // second
    );

    return parsedDateTime;
  }


  routePage(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AppointmentList(username:username)),
    );
  }

  void _clearForm() {
    setState(() {
      petName = '';
      veterinarianName = '';
      appointmentType = '';
      reasonForAppointment = '';
      ownerName = '';
      ownerPhoneNumber = '';
      ownerEmailAddress = '';
      petSpecies = '';
      petBreed = '';
      petAge = 0;
      vaccination = '';
      medicalHistory = '';
      additionalNotes = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Pet Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _petNameController,
                decoration: InputDecoration(labelText: 'Pet Name'),
                onChanged: (value) {
                  setState(() {
                    petName = value;
                  });
                },
              ),
              SizedBox(height: 16),

              DropdownButtonFormField(
                value: veterinarianName,
                items: _veterincategories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _veterincategoryController.text = value.toString();
                    veterinarianName = value.toString();
                  });
                },
                decoration: InputDecoration(labelText: 'Veterinarian'),
              ),
              SizedBox(height: 16),
              DateTimePicker(
                labelText: 'Appointment Date and Time',
                selectedDate: appointmentDateTime,
                onDateChanged: (date) {
                  setState(() {
                    appointmentDateTime = date!;
                    dateTimeController.text =
                        "${date.toLocal()}".split(' ')[0] + " ${date.toLocal()}".split(' ')[1]; // Format date and time
                  });
                },
                controller: dateTimeController, // Pass the controller here
              ),

              SizedBox(height: 16),

              DropdownButtonFormField(
                value: appointmentType,
                items: appointmentTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _appointmentTypeController.text = value.toString();
                    appointmentType = value.toString();
                  });
                },
                decoration: InputDecoration(labelText: 'Appointment Type'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(labelText: 'Reason for Appointment'),
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    reasonForAppointment = value;
                  });
                },
              ),
              SizedBox(height: 32),
              Text(
                'Owner Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _ownerPhoneController,
                decoration: InputDecoration(labelText: 'Owner Phone Number'),
                onChanged: (value) {
                  setState(() {
                    ownerPhoneNumber = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _ownerEmailController,
                decoration: InputDecoration(labelText: 'Owner Email Address'),
                onChanged: (value) {
                  setState(() {
                    ownerEmailAddress = value;
                  });
                },
              ),
              SizedBox(height: 32),
              Text(
                'Pet Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              DropdownButtonFormField(
                value: petSpecies,
                items: petSpeciesOptions.map((species) {
                  return DropdownMenuItem(
                    value: species,
                    child: Text(species),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _petSpeciesController.text = value.toString();
                    petSpecies = value.toString();
                  });
                },
                decoration: InputDecoration(labelText: 'Pet Species'),
              ),

              SizedBox(height: 16),

              DropdownButtonFormField(
                value: petBreed,
                items: petBreedOptions.map((breed) {
                  return DropdownMenuItem(
                    value: breed,
                    child: Text(breed),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _petBreedController.text = value.toString();
                    petBreed = value.toString();
                  });
                },
                decoration: InputDecoration(labelText: 'Pet Breed'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _petAgeController,
                decoration: InputDecoration(labelText: 'Pet Age'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    petAge = int.tryParse(value) ?? 0;
                  });
                },
              ),
              SizedBox(height: 16),


              DropdownButtonFormField(
                value: vaccination,
                items: vaccinationRecords.map((species) {
                  return DropdownMenuItem(
                    value: species,
                    child: Text(species),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _vaccinationController.text = value.toString();
                    vaccination = value.toString();
                  });
                },
                decoration: InputDecoration(labelText: 'Vaccination Records'),
              ),

              SizedBox(height: 16),
              TextFormField(
                controller: _medicalHistoryController,
                decoration: InputDecoration(labelText: "Pet's Medical History"),
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    medicalHistory = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _additionalNotesController,
                decoration: InputDecoration(labelText: 'Additional Notes'),
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    additionalNotes = value;
                  });
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DateTimePicker extends StatelessWidget {
  final String labelText;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateChanged;
  final TextEditingController? controller; // New controller argument

  DateTimePicker({
    required this.labelText,
    required this.selectedDate,
    required this.onDateChanged,
    this.controller, // Initialize the controller
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () async {
            final DateTime? selected = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (selected != null && selected != selectedDate) {
              onDateChanged(selected);
              if (controller != null) {
                controller!.text = _formatDate(selected);
              }
            }
          },
          child: Text(
            selectedDate != null
                ? _formatDate(selectedDate!)
                : 'Select date',
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () async {
            final TimeOfDay? selectedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (selectedTime != null) {
              final DateTime selected = DateTime(
                selectedDate!.year,
                selectedDate!.month,
                selectedDate!.day,
                selectedTime.hour,
                selectedTime.minute,
              );
              onDateChanged(selected);
              if (controller != null) {
                controller!.text = _formatTime(selected);
              }
            }
          },
          child: Text(
            selectedDate != null
                ? _formatTime(selectedDate!)
                : 'Select time',
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dateTime) {
    final formattedDate = "${dateTime.toLocal()}".split(' ')[0];
    return formattedDate;
  }

  String _formatTime(DateTime dateTime) {
    final formattedTime = "${dateTime.toLocal()}".split(' ')[1];
    return formattedTime;
  }
}


