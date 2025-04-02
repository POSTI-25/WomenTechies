

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Functionalities/saving_userID.dart';
class UserMainPage extends StatelessWidget{
  const UserMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UserPage();
  }
}
class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final MapController _mapController = MapController();
  bool showAutos = false;
  int? selectedAutoOccupants;
  int? selectedMaleOccupants;
  int? selectedFemaleOccupants;
  List<LatLng> autoLocations = [
    LatLng(12.9758527, 79.137239),
    LatLng(12.958831, 79.137249),
    LatLng(12.975635, 79.093810),
  ];
  List<int> autoOccupants = [3, 2, 2];
  List<int> maleOccupants = [2, 1, 1];
  List<int> femaleOccupants = [1, 1, 1];
  List<LatLng> routePoints = [];
  LatLng userLocation = LatLng(12.972222, 79.138333);

  TextEditingController _destinationController = TextEditingController();
  String _destination = "";

  void _onDestinationPressed() {
    setState(() {
      _destination = _destinationController.text;
      showAutos = true;
    });
    print("Destination: $_destination");
  }

  Future<void> _fetchRoute(LatLng start, LatLng end) async {
    final String apiUrl = "https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=simplified&geometries=geojson";

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List coordinates = data['routes'][0]['geometry']['coordinates'];
      setState(() {
        routePoints = coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
      });
    } else {
      print("Failed to load route");
    }
  }

  void _showOccupants(int index) {
    setState(() {
      selectedAutoOccupants = autoOccupants[index];
      selectedMaleOccupants = maleOccupants[index];
      selectedFemaleOccupants = femaleOccupants[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: showAutos
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(autoLocations.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: FloatingActionButton(
                    heroTag: 'auto$index',
                    onPressed: () {
                      _fetchRoute(autoLocations[index], userLocation);
                      _showOccupants(index);
                    },
                    child: Text("Auto ${index + 1}"),
                  ),
                );
              }),
            )
          : null,
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    labelText: "Enter Destination",
                    hintText: "Type your destination here",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _onDestinationPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Search Auto",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              Expanded(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: userLocation,
                    zoom: 15,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: userLocation,
                          builder: (ctx) => Icon(Icons.person_pin, color: Colors.blue, size: 40),
                        ),
                        if (showAutos)
                          ...List.generate(autoLocations.length, (index) => Marker(
                                point: autoLocations[index],
                                width: 100,
                                height: 60,
                                builder: (ctx) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/images/autowala_logo.png',
                                      width: 40,
                                      height: 40,
                                    ),
                                    Container(
                                    width: 50, // Constrains width to prevent overflow
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 2,
                                        )
                                      ],
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "Auto ${index + 1}",
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),

                                  ],
                                ),
                              )),
                      ],
                    ),
                    PolylineLayer(
                      polylineCulling: false,
                      polylines: [
                        if (routePoints.isNotEmpty)
                          Polyline(
                            points: routePoints,
                            color: Colors.blue,
                            strokeWidth: 6,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (selectedAutoOccupants != null)
            Center(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Number of occupants: $selectedAutoOccupants", style: TextStyle(fontSize: 20, color: Colors.white)),
                    Text("Males: $selectedMaleOccupants", style: TextStyle(fontSize: 16, color: Colors.white)),
                    Text("Females: $selectedFemaleOccupants", style: TextStyle(fontSize: 16, color: Colors.white)),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Send Request"),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: ElevatedButton(onPressed: () async{
        await removeData('id');
        await removeData('user_type');
      }, child: Text("Clear Data")),
    );
  }
}
