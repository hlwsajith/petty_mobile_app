import 'package:flutter/foundation.dart';

class Animal {
  final String animalId;
  final String imageName;
  final String animalName;
  final String specie;
  final String gender;
  final String markings;
  final String nstatus;
  final String vaccination;
  final String SpecialMedicalNeeds;
  final String temperament;
  final String behavioralIssues;
  final String ageGroup;
  final String location;
  final String contactName;
  final String contactEmail;
  final String contactPhone;
  final String storyOfAnimal;
  final String adopterRequirements;
  final String tag;

  Animal({
    required this.animalId,
    required this.imageName,
    required this.animalName,
    required this.specie,
    required this.gender,
    required this.markings,
    required this.nstatus,
    required this.vaccination,
    required this.SpecialMedicalNeeds,
    required this.temperament,
    required this.behavioralIssues,
    required this.ageGroup,
    required this.location,
    required this.contactName,
    required this.contactEmail,
    required this.contactPhone,
    required this.storyOfAnimal,
    required this.adopterRequirements,
    required this.tag,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      animalId: json['animalId'] ?? '',
      imageName: json['imageName'] ?? '',
      animalName: json['animalName'] ?? '',
      specie: json['specie'] ?? '',
      gender: json['gender'] ?? '',
      markings: json['markings'] ?? '',
      nstatus: json['nstatus'] ?? '',
      vaccination: json['vaccination'] ?? '',
      SpecialMedicalNeeds: json['SpecialMedicalNeeds'] ?? '',
      temperament: json['temperament'] ?? '',
      behavioralIssues: json['behavioralIssues'] ?? '',
      ageGroup: json['ageGroup'] ?? '',
      location: json['location'] ?? '',
      contactName: json['contactName'] ?? '',
      contactEmail: json['contactEmail'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      storyOfAnimal: json['storyOfAnimal'] ?? '',
      adopterRequirements: json['adopterRequirements'] ?? '',
      tag: json['tag'] ?? '',
    );
  }
}
