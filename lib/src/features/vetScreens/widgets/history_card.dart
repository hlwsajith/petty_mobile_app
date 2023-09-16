import 'package:adopt_v2/src/features/vetScreens/models/Appointment.dart';
import 'package:adopt_v2/src/features/vetScreens/repositories/vet_repository.dart';
import 'package:adopt_v2/src/features/vetScreens/screens/view_appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatefulWidget {
  @override
  _HistoryCardState createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  final storage = FlutterSecureStorage();
  final VetRepository _appointmentRepository = VetRepository();
  List<Appointment> appointment = [];
  String vetname = '';
  final bool isCompleted = true;

  @override
  void initState() {
    super.initState();
    _initializeData().then((_) {
      _fetchAppointments();
    });
  }

  Future<void> _initializeData() async {
    vetname = await storage.read(key: 'vetname') ?? '';

  }

  Future<void> _fetchAppointments() async {
    final fetchedData = await _appointmentRepository.fetchIncomingAppointments(vetname,'Cancelled');

    setState(() {
      appointment = fetchedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: appointment.length, // Change this to the actual number of appointments
      itemBuilder: (context, index) {
        final appointments = appointment[index];
        return GestureDetector(
          onTap: () {
            // Redirect to another screen when tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppointmentPreviewScreen(appointmentId:appointments.appointmentId), // Replace with your details screen
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.blue, // Icon color
                          ),
                          SizedBox(width: 8),
                          Text(
                            appointments.appointmentDateTime,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Text color
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.white, // Cancel icon color
                        ),
                        onPressed: () {
                          // Cancel appointment
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage('url_to_patient_image'),
                        radius: 30, // Adjust as needed
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Patient -'+ appointments.petName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Text color
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.medical_services,
                        color: Colors.blue, // Icon color
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Treatment Type -'+ appointments.appointmentType,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black, // Text color
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(
                        Icons.close,
                        color: Colors.red, // Status icon color
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 20, // Icon size
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Canceled',
                        style: TextStyle(
                          fontSize: 16,
                          color:Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AppointmentDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Build your appointment details screen here
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
      ),
      body: Center(
        child: Text('Details of the selected appointment'),
      ),
    );
  }
}
