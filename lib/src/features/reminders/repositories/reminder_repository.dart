import 'dart:convert';

import 'package:adopt_v2/src/features/reminders/models/Reminder.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReminderRepository {
  final String baseUrl = 'http://192.168.1.6:8000';

  Future<void> addReminder(
      String title,
      String petName,
      String? reminderType,
      String? frequency,
      DateTime? date,
      TimeOfDay? time,
      String user,
      DateTime now,
      ) async {
    final url = 'YOUR_API_ENDPOINT'; // Replace with your actual API endpoint

    // Prepare the request body with the necessary data
    final requestBody = {
      'title': title,
      'petName': petName,
      'reminderType': reminderType,
      'frequency': frequency,
      'date': date?.toString(),
      'time': time?.toString(),
      'user': user,
      'now': now.toString(),
    };

    try {
      final response = await http.post(Uri.parse(url), body: requestBody);
      if (response.statusCode == 200) {
        // Request successful, handle the response if needed
        print('Reminder added successfully');
      } else {
        // Request failed, handle the error
        print('Failed to add reminder');
      }
    } catch (e) {
      // Exception occurred, handle the error
      print('Error: $e');
    }
  }

  Future<List<Reminder>> fetchAllReminders() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/reminder/getallreminders'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData != null && jsonData is List) {
          List<Reminder> fetchedData = jsonData.map((json) => Reminder.fromJson(json)).toList();
          return fetchedData;

        } else {
          throw Exception('Invalid Reminder data format');
        }
      } else {
        throw Exception('Failed to fetch Reminder data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch Reminder data: $e');
    }
  }

}