import 'package:flutter/material.dart';

class VetBottomBar extends StatefulWidget {
  @override
  _VetBottomBarState createState() => _VetBottomBarState();
}

class _VetBottomBarState extends State<VetBottomBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding screen based on the selected index
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/vethome');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/appointments');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/patienthistory');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/vetmessage');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/vetprofile');
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the current route name
    String currentRoute = ModalRoute.of(context)!.settings.name ?? '';

    // Determine the selected index based on the current route
    int newIndex = 0;
    switch (currentRoute) {
      case '/vethome':
        newIndex = 0;
        break;
      case '/appointments':
        newIndex = 1;
        break;
      case '/patienthistory':
        newIndex = 2;
        break;
      case '/vetmessage':
        newIndex = 3;
        break;
      case '/vetprofile':
        newIndex = 4;
        break;
    }

    // Update the selected index if it has changed
    if (_selectedIndex != newIndex) {
      setState(() {
        _selectedIndex = newIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home),
            color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
            onPressed: () {
              _onItemTapped(0);
            },
          ),
          IconButton(
            icon: Icon(Icons.medical_services),
            color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
            onPressed: () {
              _onItemTapped(1);
            },
          ),
          RawMaterialButton(
            shape: CircleBorder(),
            fillColor: _selectedIndex == 2 ? Colors.blue : Colors.grey,
            onPressed: () {
              _onItemTapped(2);
            },
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(
                Icons.medical_information,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.sms),
            color: _selectedIndex == 3 ? Colors.blue : Colors.grey,
            onPressed: () {
              _onItemTapped(3);
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            color: _selectedIndex == 4 ? Colors.blue : Colors.grey,
            onPressed: () {
              _onItemTapped(4);
            },
          ),
        ],
      ),
    );
  }
}
