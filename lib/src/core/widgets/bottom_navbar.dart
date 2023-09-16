import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding screen based on the selected index
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/list');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/shop');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/prediction');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
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
      case '/home':
        newIndex = 0;
        break;
      case '/list':
        newIndex = 1;
        break;
      case '/shop':
        newIndex = 2;
        break;
      case '/prediction':
        newIndex = 3;
        break;
      case '/profile':
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
            color: _selectedIndex == 0 ? Color(0xff941F1C) : Colors.grey,
            onPressed: () {
              _onItemTapped(0);
            },
          ),
          IconButton(
            icon: Icon(Icons.pets),
            color: _selectedIndex == 1 ? Color(0xff941F1C) : Colors.grey,
            onPressed: () {
              _onItemTapped(1);
            },
          ),
          RawMaterialButton(
            shape: CircleBorder(),
            fillColor: _selectedIndex == 2 ? Color(0xff941F1C) : Colors.grey,
            onPressed: () {
              _onItemTapped(2);
            },
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(
                Icons.storefront,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.batch_prediction),
            color: _selectedIndex == 3 ? Color(0xff941F1C) : Colors.grey,
            onPressed: () {
              _onItemTapped(3);
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            color: _selectedIndex == 4 ? Color(0xff941F1C) : Colors.grey,
            onPressed: () {
              _onItemTapped(4);
            },
          ),
        ],
      ),
    );
  }
}
