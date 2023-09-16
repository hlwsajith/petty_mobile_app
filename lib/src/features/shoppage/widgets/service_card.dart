import 'package:adopt_v2/src/features/shoppage/models/VetsService.dart';
import 'package:adopt_v2/src/features/shoppage/widgets/add_service.dart';
import 'package:flutter/material.dart';
import 'package:adopt_v2/src/features/shoppage/repositories/shop_repository.dart';
import 'package:adopt_v2/src/features/shoppage/models/Services.dart';

class ServiceCard extends StatefulWidget {
  final String searchQuery;
  final bool isLoading;
  final VoidCallback onSearchStart;

  ServiceCard({
    required this.searchQuery,
    required this.isLoading,
    required this.onSearchStart,
  });

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  List<VetsService> serviceList = [];

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  @override
  void didUpdateWidget(ServiceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      fetchServices();
    }else{
      print('Failed to fetch services');
    }
  }

  Future<void> fetchServices() async {
    try {
      List<VetsService> fetchedData;
      if (widget.searchQuery.isNotEmpty) {
        fetchedData = await ShopRepository().searchServices(widget.searchQuery);
      } else {
        fetchedData = await ShopRepository().fetchAllServices();
      }
      setState(() {
        serviceList = fetchedData;
      });
    } catch (e) {
      print('Failed to fetch services: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return GridView.builder(
        itemCount: serviceList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.90,
        ),
        itemBuilder: (BuildContext context, int index) {
          VetsService service = serviceList[index]; // Use serviceList here

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddService(vetname:service.vetname)),
              );
            },
            child: Stack(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  color: Color(0xffF2F2F2),
                  margin: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 335,
                    height: 395, // Set height to 375 pixels
                    child: Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 16.0,
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  service.vetname,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff941F1C),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  service.location, // Display service description
                                  style: TextStyle(
                                    fontSize: 14,
                                    // fontWeight: FontWeight.bold,
                                    color: Color(0xffF2759D),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  service.vetcategory, // Display service price
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff941F1C),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Color(0xffe67e22),
                                        size: 16.0,
                                      ),
                                      SizedBox(width: 4.0),
                                      Text(
                                        '4.5 (100 ratings)', // Display ratings and count
                                        style: TextStyle(
                                          fontSize: 14,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 19,
                  top: 35,
                  child: getImageBasedOnCategory(service.vetcategory),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
Widget getImageBasedOnCategory(String category) {
  String imagePath;

  // Determine the image path based on the category value
  if (category == 'Surgery') {
    imagePath = 'assets/images/Surgery.jpg'; // Replace with the actual image path for Category1
  } else if (category == 'Dentistry') {
    imagePath = 'assets/images/Dentistry.jpg'; // Replace with the actual image path for Category2
  } else if (category == 'Exotics') {
    imagePath = 'assets/images/Exotics.jpg'; // Replace with the actual image path for Category3
  } else if (category == 'Ophthalmology') {
    imagePath = 'assets/images/Ophthalmology.jpg'; // Default image path if category is not recognized
  }else {
    imagePath = 'assets/images/Ophthalmology.png';
  }

  return Image.asset(
    imagePath,
    width: 178,
    fit: BoxFit.cover,
  );
}

