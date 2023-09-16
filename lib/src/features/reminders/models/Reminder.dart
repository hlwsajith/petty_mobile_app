import 'package:flutter/material.dart';

class Reminder {
  final int Reminderid;
  final String title;
  final String name;
  final String description;
  final String type;
  final String frequency;
  final DateTime date;
  final TimeOfDay time;
  final String user;
  final DateTime createdAt;

  Reminder({
    required this.Reminderid,
    required this.title,
    required this.name,
    required this.description,
    required this.type,
    required this.frequency,
    required this.date,
    required this.time,
    required this.user,
    required this.createdAt,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      Reminderid: json['Reminderid'],
      title: json['title'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      frequency: json['frequency'],
      date: DateTime.parse(json['date']),
      time: TimeOfDay.fromDateTime(DateTime.parse(json['date'])),
      user: json['user'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
