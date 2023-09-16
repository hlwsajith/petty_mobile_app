// donation_repository.dart
class DonationRepository {
  static Future<List<String>> fetchDonations() async {
    // API call to fetch donation data
    await Future.delayed(Duration(seconds: 2)); // Simulating an API call delay
    return ['Donation 1', 'Donation 2', 'Donation 3', 'Donation 4'];
  }

  static Future<List<String>> fetchVolunteers() async {
    // API call to fetch volunteer data
    await Future.delayed(Duration(seconds: 2)); // Simulating an API call delay
    return ['Volunteer 1', 'Volunteer 2', 'Volunteer 3', 'Volunteer 4'];
  }

  static Future<List<String>> fetchFosterCare() async {
    // API call to fetch foster care data
    await Future.delayed(Duration(seconds: 2)); // Simulating an API call delay
    return ['Foster Care 1', 'Foster Care 2', 'Foster Care 3', 'Foster Care 4'];
  }
}
