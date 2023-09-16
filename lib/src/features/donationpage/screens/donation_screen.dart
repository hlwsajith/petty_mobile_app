import 'package:adopt_v2/src/core/widgets/bottom_navbar.dart';
import 'package:adopt_v2/src/features/donationpage/repositories/donation_repository.dart';
import 'package:adopt_v2/src/features/donationpage/widgets/donation_card.dart';
import 'package:adopt_v2/src/features/donationpage/widgets/foster_card.dart';
import 'package:adopt_v2/src/features/donationpage/widgets/volunteer_card.dart';
import 'package:flutter/material.dart';

class DonationScreen extends StatefulWidget {
  @override
  _DonationScreenState createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  int activeIndex = 0;
  List<String> donationData = [];
  List<String> volunteerData = [];
  List<String> fosterCareData = [];

  @override
  void initState() {
    super.initState();
    fetchDonationData();
  }

  Future<void> fetchDonationData() async {
    List<String> data = await DonationRepository.fetchDonations();
    setState(() {
      donationData = data;
    });
  }

  Future<void> fetchVolunteerData() async {
    List<String> data = await DonationRepository.fetchVolunteers();
    setState(() {
      volunteerData = data;
    });
  }

  Future<void> fetchFosterCareData() async {
    List<String> data = await DonationRepository.fetchFosterCare();
    setState(() {
      fosterCareData = data;
    });
  }

  Widget buildGridView() {
    if (activeIndex == 0) {
      // Donation grid view
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
        ),
        itemCount: donationData.length,
        itemBuilder: (BuildContext context, int index) {
          final donation = donationData[index];
          return DonationCard(
            title: donation,
            description: 'Donation Description',
            imageUrl: 'https://example.com/donation_image_$index.jpg',
          );
        },
        padding: EdgeInsets.all(16.0),
      );
    } else if (activeIndex == 1) {
      // Volunteer grid view
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
        ),
        itemCount: volunteerData.length,
        itemBuilder: (BuildContext context, int index) {
          final volunteer = volunteerData[index];
          return VolunteerCard(
            title: volunteer,
            description: 'Volunteer Description',
            imageUrl: 'https://example.com/volunteer_image_$index.jpg',
          );
        },
        padding: EdgeInsets.all(16.0),
      );
    } else {
      // Foster Care grid view
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
        ),
        itemCount: fosterCareData.length,
        itemBuilder: (BuildContext context, int index) {
          final fosterCare = fosterCareData[index];
          return FosterCard(
            title: fosterCare,
            description: 'Foster Care Description',
            imageUrl: 'https://example.com/foster_care_image_$index.jpg',
          );
        },
        padding: EdgeInsets.all(16.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Screen'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    activeIndex = 0;
                    fetchDonationData();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: activeIndex == 0 ? Colors.blue : Colors.grey,
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Donation',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    activeIndex = 1;
                    fetchVolunteerData();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: activeIndex == 1 ? Colors.blue : Colors.grey,
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Volunteer',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    activeIndex = 2;
                    fetchFosterCareData();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: activeIndex == 2 ? Colors.blue : Colors.grey,
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Foster Care',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: buildGridView(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
