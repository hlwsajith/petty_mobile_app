import 'package:flutter/material.dart';

class AdminBottomBar extends StatefulWidget {
  @override
  _AdminBottomBarState createState() => _AdminBottomBarState();
}

class _AdminBottomBarState extends State<AdminBottomBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding screen based on the selected index
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/adminhome');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/adminlisting');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/adminproducts');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/adminappoint');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/adminprofile');
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
      case '/adminhome':
        newIndex = 0;
        break;
      case '/adminlisting':
        newIndex = 1;
        break;
      case '/adminproducts':
        newIndex = 2;
        break;
      case '/adminappoint':
        newIndex = 3;
        break;
      case '/adminprofile':
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
            icon: Icon(Icons.pets),
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
                Icons.storefront,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.medical_services),
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
