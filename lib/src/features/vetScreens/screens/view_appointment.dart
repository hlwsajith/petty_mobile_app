import 'package:adopt_v2/src/core/widgets/message_dialog.dart';
import 'package:adopt_v2/src/features/adminscreen/screens/manage_appointments.dart';
import 'package:flutter/material.dart';
import 'package:adopt_v2/src/features/vetScreens/models/Appointment.dart';
import 'package:adopt_v2/src/features/vetScreens/repositories/vet_repository.dart';
import 'package:adopt_v2/src/features/vetScreens/screens/appointment_history.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppointmentPreviewScreen extends StatefulWidget {
  final String appointmentId;

  AppointmentPreviewScreen({
    required this.appointmentId,
  });

  @override
  _AppointmentPreviewScreenState createState() =>
      _AppointmentPreviewScreenState();
}

class _AppointmentPreviewScreenState extends State<AppointmentPreviewScreen> {
  final storage = FlutterSecureStorage();
  Appointment? appointment;
  String usertype = '';

  @override
  void initState() {
    super.initState();
    _initializeData().then((_) {
    fetchAppointmentDetails();
    });
  }

  Future<void> _initializeData() async {
    usertype = await storage.read(key: 'usertype') ?? '';
    setState(() {
      usertype = usertype;
    });
  }

  Future<void> fetchAppointmentDetails() async {
    VetRepository repository = VetRepository();
    Appointment? fetchedData =
    await repository.fetchAppointmentData(widget.appointmentId);

    setState(() {
      appointment = fetchedData;
    });
  }

  Future<void> changeStatus(String status, String appointmentId) async {
    VetRepository repository = VetRepository();
    int responseCode =
    (await repository.changeStatus(status, appointmentId)) as int;

    if (responseCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MessageDialog(
            title: 'Successful',
            content: 'Appointment Updated Successful',
            icon: Icons.check_circle,
            iconColor: Colors.green,
            buttonColor: Colors.green,
            buttonText: 'OK',
            onButtonPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              if(usertype == 'admin'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageAppointments(),
                  ),
                );
              }else{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentHistory(),
                  ),
                );

              }

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
            content: 'Appointment Updated Unsuccessful',
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
  }

  @override
  Widget build(BuildContext context) {
    if (appointment == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Appointment Preview'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      Widget statusWidget;

      if (appointment!.appointmentStatus == 'Incoming') {
        statusWidget = Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                changeStatus('Completed', appointment!.appointmentId);
              },
              icon: Icon(Icons.check),
              label: Text('Accept'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                changeStatus('Cancelled', appointment!.appointmentId);
              },
              icon: Icon(Icons.close),
              label: Text('Cancel'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      } else if (appointment!.appointmentStatus == 'Cancelled') {
        statusWidget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.close,
              color: Colors.red,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Canceled',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      } else if (appointment!.appointmentStatus == 'Completed') {
        statusWidget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
              color: Colors.green,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Completed',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      } else {
        // Handle other appointmentStatus values here
        statusWidget = SizedBox(); // Hide the buttons if status is not recognized
      }

      return Scaffold(
        appBar: AppBar(
          title: Text('Appointment Preview'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCard(
                'Pet Information',
                Icons.pets,
                Color(0xffC77378),
                <Widget>[
                  _buildPreviewRow('Pet Name', appointment!.petName),
                  _buildPreviewRow(
                      'Veterinarian Name', appointment!.veterinarianName),
                  _buildPreviewRow(
                      'Appointment Date and Time',
                      appointment!.appointmentDateTime),
                  _buildPreviewRow('Appointment Type', appointment!.appointmentType),
                  _buildPreviewRow(
                      'Reason for Appointment',
                      appointment!.reasonForAppointment),
                ],
              ),
              SizedBox(height: 32),
              _buildCard(
                'Owner Information',
                Icons.person,
                Color(0xffC77378),
                <Widget>[
                  _buildPreviewRow('Owner Name', appointment!.ownerName),
                  _buildPreviewRow(
                      'Owner Phone Number', appointment!.ownerPhoneNumber),
                  _buildPreviewRow(
                      'Owner Email Address', appointment!.ownerEmailAddress),
                ],
              ),
              SizedBox(height: 32),
              _buildCard(
                'Pet Details',
                Icons.pets,
                Color(0xffC77378),
                <Widget>[
                  _buildPreviewRow('Pet Species', appointment!.petSpecies),
                  _buildPreviewRow('Pet Breed', appointment!.petBreed),
                  _buildPreviewRow('Pet Age', appointment!.petAge.toString()),
                  _buildPreviewRow(
                      'Vaccination Records', appointment!.vaccinationRecords),
                  _buildPreviewRow(
                      "Pet's Medical History", appointment!.medicalHistory),
                  _buildPreviewRow('Additional Notes', appointment!.additionalNotes),
                ],
              ),
              SizedBox(height: 16),
              statusWidget,
            ],
          ),
        ),
      );
    }
  }

  Widget _buildCard(String title, IconData icon, Color iconColor, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff941F1C),
                  ),
                ),
                Icon(
                  icon,
                  color: iconColor,
                ),
              ],
            ),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
