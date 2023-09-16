import 'package:adopt_v2/src/core/widgets/admin_bottombar.dart';
import 'package:adopt_v2/src/core/widgets/vet_bottombar.dart';
import 'package:adopt_v2/src/features/vetScreens/models/Appointment.dart';
import 'package:adopt_v2/src/features/vetScreens/repositories/vet_repository.dart';
import 'package:adopt_v2/src/features/vetScreens/screens/add_appointment.dart';
import 'package:adopt_v2/src/features/vetScreens/screens/view_appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class ManageAppointments extends StatefulWidget {
  @override
  _ManageAppointmentsState createState() => _ManageAppointmentsState();
}

class _ManageAppointmentsState extends State<ManageAppointments> {
  TextEditingController _searchController = TextEditingController();
  final storage = FlutterSecureStorage();
  bool _isLoading = false;
  // late List<Appointment> _appointments = [];
  List<Appointment> appointment = [];
  // Appointment? appointment;
  String vetname = '';
  String usertype = '';

  final VetRepository _appointmentRepository = VetRepository();

  @override
  void initState() {
    super.initState();
    _initializeData().then((_) {
      _fetchAppointments();
    });

  }

  Future<void> _initializeData() async {
    vetname = await storage.read(key: 'vetname') ?? '';
    usertype = await storage.read(key: 'usertype') ?? '';
    setState(() {
      usertype= usertype;
    });
  }

  Future<void> _fetchAppointments() async {
    final fetchedData = await _appointmentRepository.fetchAllAppointments();

    setState(() {
      appointment = fetchedData;
    });
  }

  // Future<void> _fetchAppointments() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   try {
  //     final appointments = await _appointmentRepository.fetchAppointments(vetname);
  //     setState(() {
  //       _appointments = appointments;
  //       _isLoading = false;
  //     });
  //   } catch (error) {
  //     print('Error fetching appointments: $error');
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  void _triggerSearch() async {
    // Add a delay of 1 second before triggering the search
    await Future.delayed(Duration(seconds: 1));

    if (mounted) {
      // Check if the widget is still mounted before updating the state
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Search',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _isLoading = true;
                            _triggerSearch();
                          });
                        },
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _isLoading = true;
                        _searchController.text = value;
                        _triggerSearch();
                      });
                    },
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AppointmentForm()),
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add New'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff4FC9E0),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: appointment.length,
              itemBuilder: (BuildContext context, int index) {
                final appointments = appointment[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
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
                                  Icon(Icons.calendar_today),
                                  SizedBox(width: 8),
                                  Text(appointments.appointmentDateTime),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.cancel),
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
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Patient -'+ appointments.petName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.medical_services),
                              SizedBox(width: 8),
                              Text(appointments.appointmentType),
                              SizedBox(width: 16),
                              Icon(Icons.info),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AppointmentPreviewScreen(appointmentId: appointments.appointmentId),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.open_in_new),
                                label: Text('View'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  textStyle: TextStyle(fontSize: 16),
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
            ),
          ),
        ],
      ),
      bottomNavigationBar: AdminBottomBar(),
    );
  }
}
