import 'dart:async';

import 'package:adopt_v2/src/core/widgets/vet_bottombar.dart';
import 'package:adopt_v2/src/features/vetScreens/widgets/history_card.dart';
import 'package:adopt_v2/src/features/vetScreens/widgets/incoming_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentHistory extends StatefulWidget {
  @override
  _AppointmentHistoryState createState() => _AppointmentHistoryState();
}
class _AppointmentHistoryState extends State<AppointmentHistory> with TickerProviderStateMixin {
  int currentPage = 1;
  int pageSize = 10;
  int activeIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  bool isLoading = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        activeIndex = _tabController.index;
      });
    });
    _pageController = PageController(initialPage: activeIndex);

    // Start auto-sliding
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (activeIndex < 2) {
        activeIndex++;
      } else {
        activeIndex = 0;
      }
      _pageController.animateToPage(
        activeIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }
  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment History'),
        backgroundColor: Color(0xff4FC9E0),
        automaticallyImplyLeading: false,
      ),
      body: Column(
          children: [
            SizedBox(height: 16),
            TabBar(
              indicator: BoxDecoration(
                color: Color(0xff4FC9E0), // Set the active tab's background color
                borderRadius: BorderRadius.circular(10.0),
              ),
              labelColor: Colors.white, // Set the active tab's text color
              unselectedLabelColor:
              Colors.grey, // Set the inactive tab's text color
              onTap: (index) {
                setState(() {
                  activeIndex = index;
                });
              },
              controller: _tabController,
              tabs: [
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
            SizedBox(height: 16),
            Flexible(
              child: TabBarView(
                controller: _tabController,
                children: [
                  IncomingCard(),
                  HistoryCard(),
                ],
              ),
            ),
          ]),
      bottomNavigationBar: VetBottomBar(),
    );
  }

}