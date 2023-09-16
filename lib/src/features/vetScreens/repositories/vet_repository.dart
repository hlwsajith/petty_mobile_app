import 'dart:convert';
import 'package:adopt_v2/src/features/chatScreen/models/Chat.dart';
import 'package:adopt_v2/src/features/vetScreens/models/Appointment.dart';
import 'package:http/http.dart' as http;
import 'package:adopt_v2/src/features/vetScreens/models/VetChatLists.dart';


class VetRepository {
  final String baseUrl = 'http://192.168.1.6:8000';

  Future<List<VetChatLists>> fetchData(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/message/fetchChatLists?username=$username')); // Update the API endpoint

    if (response.statusCode == 200) {

      final jsonData = json.decode(response.body);
      final List<VetChatLists> chatLists = [];

      for (var chatData in jsonData) {
        chatLists.add(VetChatLists.fromJson(chatData));
      }

      return chatLists;
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Future<Appointment> fetchAppointmentData(String appointmentId) async {
  //   final response = await http.get(Uri.parse('$baseUrl/message/fetchChatLists?appointmentId=$appointmentId'));
  //
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> jsonData = json.decode(response.body);
  //     return Appointment.fromJson(jsonData);
  //   } else {
  //     throw Exception('Failed to load appointment data');
  //   }
  // }



  Future<Appointment?> fetchAppointmentData(String appointmentId) async {
    // Make an API call to fetch the details of a specific animal
    // Replace this with your actual API call implementation
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/vets/getonedetails?appointmentId=$appointmentId'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        Appointment fetchedData = Appointment.fromJson(jsonData);
        return fetchedData;
      } else {
        throw Exception('Failed to fetch Appointment details');
      }
    } catch (e) {
      throw Exception('Failed to fetch Appointment details: $e');
    }
  }

  // Future<List<Appointment>> fetchAppointments(String vetname) async {
  //   final response = await http.get(Uri.parse('$baseUrl/message/fetchChatLists?vetname=$vetname'));
  //
  //   if (response.statusCode == 200) {
  //     final List<dynamic> jsonData = json.decode(response.body);
  //     return jsonData.map((appointmentData) => Appointment.fromJson(appointmentData)).toList();
  //   } else {
  //     throw Exception('Failed to load appointments');
  //   }
  // }

  Future<List<Appointment>> fetchAllAppointments() async {
    // Make an API call to fetch the details of a specific animal
    // Replace this with your actual API call implementation
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/vets/getalllist')); 
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<Appointment> AppointmentLists = [];

        for (var AppointmentData in jsonData) {
          AppointmentLists.add(Appointment.fromJson(AppointmentData));
        }

        return AppointmentLists;
      } else {
        throw Exception('Failed to fetch product details');
      }
    } catch (e) {
      throw Exception('Failed to fetch product details: $e');
    }
  }

  Future<List<Appointment>> fetchAppointments(String vetname) async {
    // Make an API call to fetch the details of a specific animal
    // Replace this with your actual API call implementation
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/vets/getonelist?vetname=$vetname'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<Appointment> AppointmentLists = [];

        for (var AppointmentData in jsonData) {
          AppointmentLists.add(Appointment.fromJson(AppointmentData));
        }

        return AppointmentLists;
      } else {
        throw Exception('Failed to fetch product details');
      }
    } catch (e) {
      throw Exception('Failed to fetch product details: $e');
    }
  }
  Future<List<Appointment>> fetchIncomingAppointments(String vetname, String incoming) async {
    // Make an API call to fetch the details of a specific animal
    // Replace this with your actual API call implementation
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/vets/getoneincominglist?vetname=$vetname&incoming=$incoming'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<Appointment> AppointmentLists = [];

        for (var AppointmentData in jsonData) {
          AppointmentLists.add(Appointment.fromJson(AppointmentData));
        }

        return AppointmentLists;
      } else {
        throw Exception('Failed to fetch product details');
      }
    } catch (e) {
      throw Exception('Failed to fetch product details: $e');
    }
  }

  Future<List<Appointment>> fetchUserAppointments(String username) async {
    // Make an API call to fetch the details of a specific animal
    // Replace this with your actual API call implementation
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/vets/getoneuserlist?username=$username'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<Appointment> AppointmentLists = [];

        for (var AppointmentData in jsonData) {
          AppointmentLists.add(Appointment.fromJson(AppointmentData));
        }

        return AppointmentLists;
      } else {
        throw Exception('Failed to fetch product details');
      }
    } catch (e) {
      throw Exception('Failed to fetch product details: $e');
    }
  }

  Future<int?> saveAppointment(Appointment appointmentData) async {
    try {

      final response = await http.post(
        Uri.parse('$baseUrl/vets/createappointment'),
        body: {
          'appointmentId': appointmentData.appointmentId,
          'petName': appointmentData.petName,
          'veterinarianName': appointmentData.veterinarianName,
          'appointmentDateTime': appointmentData.appointmentDateTime,
          'appointmentType': appointmentData.appointmentType,
          'reasonForAppointment': appointmentData.reasonForAppointment,
          'ownerName': appointmentData.ownerName,
          'ownerPhoneNumber': appointmentData.ownerPhoneNumber,
          'ownerEmailAddress': appointmentData.ownerEmailAddress,
          'petSpecies': appointmentData.petSpecies,
          'petBreed': appointmentData.petBreed,
          'petAge': appointmentData.petAge.toString(),
          'vaccinationRecords': appointmentData.vaccinationRecords,
          'medicalHistory': appointmentData.medicalHistory,
          'additionalNotes': appointmentData.additionalNotes,
          'appointmentStatus': appointmentData.appointmentStatus, 
        },
      );

      if (response.statusCode == 201) {
        return response.statusCode;
      } else {
        return null; // Or handle error accordingly
      }
    } catch (e) {
      print('Error saving Appointment: $e');
      return null; // Or handle error accordingly
    }
  }

  Future<int> changeStatus(String status,String appointmentId) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/vets/changeStatus?status=$status&appointmentId=$appointmentId'),
      );


      if (response.statusCode == 200) {
        // Success response
        final responseData = json.decode(response.body);

        // You can process responseData as needed, e.g., return a message
        return response.statusCode;
      } else {
        // Handle other status codes (e.g., error handling)
        throw Exception('Failed to change status: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      throw Exception('Error: $error');
    }
  }

  Future<List<Chat>> fetchParticularVetChats(String vetname, String username) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/message/fetchParticularsvChats?receiver=$vetname&sender=$username'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData != null && jsonData is List) {
          List<Chat> fetchedData = List<Chat>.from(jsonData.map((json) {
            return Chat.fromJson(json as Map<String, dynamic>);
          }));
          print(fetchedData);
          return fetchedData;
        } else {
          throw Exception('Invalid Chat data format');
        }
      } else {
        throw Exception('Failed to fetch Chat data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch Chat data: $e');
    }
  }


}