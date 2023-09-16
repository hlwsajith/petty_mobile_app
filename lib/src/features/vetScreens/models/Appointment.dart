class Appointment {
  final String appointmentId;
  final String petName;
  final String veterinarianName;
  final String appointmentDateTime;
  final String appointmentType;
  final String reasonForAppointment;
  final String ownerName;
  final String ownerPhoneNumber;
  final String ownerEmailAddress;
  final String petSpecies;
  final String petBreed;
  final int petAge;
  final String vaccinationRecords;
  final String medicalHistory;
  final String additionalNotes;
  final String appointmentStatus;

  Appointment({
    required this.appointmentId,
    required this.petName,
    required this.veterinarianName,
    required this.appointmentDateTime,
    required this.appointmentType,
    required this.reasonForAppointment,
    required this.ownerName,
    required this.ownerPhoneNumber,
    required this.ownerEmailAddress,
    required this.petSpecies,
    required this.petBreed,
    required this.petAge,
    required this.vaccinationRecords,
    required this.medicalHistory,
    required this.additionalNotes,
    required this.appointmentStatus,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointmentId'],
      petName: json['petName'],
      veterinarianName: json['veterinarianName'],
      appointmentDateTime: json['appointmentDateTime'],
      appointmentType: json['appointmentType'],
      reasonForAppointment: json['reasonForAppointment'],
      ownerName: json['ownerName'],
      ownerPhoneNumber: json['ownerPhoneNumber'],
      ownerEmailAddress: json['ownerEmailAddress'],
      petSpecies: json['petSpecies'],
      petBreed: json['petBreed'],
      petAge: json['petAge'],
      vaccinationRecords: json['vaccinationRecords'],
      medicalHistory: json['medicalHistory'],
      additionalNotes: json['additionalNotes'],
      appointmentStatus: json['appointmentStatus'],
    );
  }
}
