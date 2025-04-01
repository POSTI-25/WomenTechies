
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:project/api.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class UserPage extends StatefulWidget {
//   const UserPage({super.key});

//   @override
//   State<UserPage> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<UserPage> {
//   List<LatLng> routePoints = []; // All points that form the complete route
//   List<LatLng> currentSegmentPoints =
//       []; // Points for the current segment being fetched
//   List<LatLng> locationMarkers = []; // All locations added by the user
//   bool isLoading = false;
//   bool showDummyIcons = false;
//   final MapController _mapController = MapController();

//   TextEditingController _destinationController = TextEditingController();
//   String _destination = "";

//   void _onDestinationPressed() {
//     setState(() {
//       _destination =
//           _destinationController
//               .text;
//               showDummyIcons = true; // Get the destination entered by the user
//     });

//     // You can now use _destination as the value for your destination input
//     print("Destination: $_destination");

//     // You could also navigate or perform any other action
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Set default start point with precise coordinates
//     locationMarkers.add(const LatLng(12.972222, 79.138333));
//   }

//   Future<void> getCoordinates() async {
//     if (locationMarkers.length < 2) return;

//     setState(() {
//       isLoading = true;
//       currentSegmentPoints = []; // Clear current segment while loading
//     });

//     try {
//       // Get the last two locations to draw the segment between them
//       final startPoint = locationMarkers[locationMarkers.length - 2];
//       final endPoint = locationMarkers.last;

//       // Format coordinates with higher precision
//       final startCoords =
//           "${startPoint.longitude.toStringAsFixed(6)},${startPoint.latitude.toStringAsFixed(6)}";
//       final endCoords =
//           "${endPoint.longitude.toStringAsFixed(6)},${endPoint.latitude.toStringAsFixed(6)}";

//       var response = await http.get(getRouteUrl(startCoords, endCoords));

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         final coordinates = data['features'][0]['geometry']['coordinates'];

//         // Verify we received valid coordinates
//         if (coordinates is List && coordinates.isNotEmpty) {
//           setState(() {
//             currentSegmentPoints =
//                 coordinates
//                     .map(
//                       (p) => LatLng(
//                         double.parse(p[1].toString()),
//                         double.parse(p[0].toString()),
//                       ),
//                     )
//                     .toList();

//             // Combine all segments to form the complete route
//             if (routePoints.isNotEmpty) {
//               // Remove the last point to avoid duplicates when combining
//               routePoints.removeLast();
//             }
//             routePoints.addAll(currentSegmentPoints);
//           });

//           // Adjust map view to show the entire route
//           _adjustMapView();
//         }
//       } else {
//         throw Exception('Failed to load route: ${response.statusCode}');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void _adjustMapView() {
//     if (routePoints.isEmpty || locationMarkers.isEmpty) return;

//     // Create bounds that include all markers and the route
//     final bounds = LatLngBounds.fromPoints([
//       ...locationMarkers,
//       ...routePoints,
//     ]);

//     // Animate map to show the entire route with some padding
//     _mapController.fitBounds(
//       bounds,
//       options: FitBoundsOptions(padding: EdgeInsets.all(40)),
//     );
//   }

//   void _handleTap(TapPosition tapPosition, LatLng latlng) {
//     setState(() {
//       locationMarkers.add(latlng);
//     });

//     // Show the exact coordinates in a snackbar for debugging
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'Added location: ${latlng.latitude.toStringAsFixed(6)}, ${latlng.longitude.toStringAsFixed(6)}',
//         ),
//         duration: Duration(seconds: 20),
//       ),
//     );

//     // Automatically fetch route if we have at least 2 points
//     if (locationMarkers.length >= 2) {
//       getCoordinates();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           // TextField for destination input
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: TextField(
//               controller: _destinationController,
//               decoration: InputDecoration(
//                 labelText: "Enter Destination",
//                 hintText: "Type your destination here",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.blue, width: 1.5),
//                 ),
//               ),
//             ),
//           ),

//           // ElevatedButton for the searching action
//           ElevatedButton(
//             onPressed: _onDestinationPressed,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue,
//               padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: Text(
//               "Search Auto",
//               style: TextStyle(fontSize: 18, color: Colors.white),
//             ),
//           ),

//           // FlutterMap widget for the map
//           Expanded(
//             child: FlutterMap(
//               mapController: _mapController,
//               options: MapOptions(
//                 zoom: 15,
//                 center: locationMarkers.first,
//                 onTap: _handleTap,
//                 interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate:
//                       "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                   subdomains: ['a', 'b', 'c'],
//                   userAgentPackageName: 'com.example.app',
//                   maxZoom: 19,
//                 ),

//                 MarkerLayer(
//                   markers: [
//                     // Existing location markers
//                     ...locationMarkers.asMap().entries.map((entry) {
//                       final index = entry.key;
//                       final point = entry.value;
//                       return Marker(
//                         point: point,
//                         width: 80,
//                         height: 80,
//                         builder:
//                             (context) => Icon(
//                               Icons.location_pin,
//                               color:
//                                   index == 0
//                                       ? Colors.green
//                                       : (index == locationMarkers.length - 1
//                                           ? Colors.red
//                                           : Colors.blue),
//                               size: 45,
//                             ),
//                       );
//                     }).toList(),

//                     // Dummy icons at fixed locations
//                     if (showDummyIcons)
//                     ...[
//                       LatLng(12.9758527, 79.137239), // First location
//                       LatLng(12.958831, 79.137249), // Second location
//                       LatLng(12.975635, 79.093810), // Third location
//                     ].map(
//                       (coord) => Marker(
//                         point: coord,
//                         width: 50,
//                         height: 50,
//                         builder:
//                             (context) => Image.asset('assets/images/autowala_logo.png'),
//                       ),
//                     ),
//                   ],
//                 ),

//                 PolylineLayer(
//                   polylineCulling: false,
//                   polylines: [
//                     if (routePoints.isNotEmpty)
//                       Polyline(
//                         points: routePoints,
//                         color: Colors.blue.withOpacity(0.7),
//                         strokeWidth: 6,
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // Buttons
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 if (locationMarkers.length >= 2 && routePoints.isNotEmpty)
//                   FloatingActionButton(
//                     heroTag: 'distance',
//                     mini: true,
//                     backgroundColor: Colors.white,
//                     onPressed: () {
//                       final distance = _calculateDistance();
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             'Total distance: ${distance.toStringAsFixed(2)} km',
//                           ),
//                         ),
//                       );
//                     },
//                     child: const Icon(Icons.straighten, color: Colors.blue),
//                   ),
//                 const SizedBox(width: 10),
//                 FloatingActionButton(
//                   heroTag: 'clear',
//                   mini: true,
//                   backgroundColor: Colors.white,
//                   onPressed: () {
//                     setState(() {
//                       locationMarkers = [
//                         locationMarkers.first,
//                       ]; // Keep only the first point
//                       routePoints = [];
//                       currentSegmentPoints = [];
//                     });
//                   },
//                   child: const Icon(Icons.clear, color: Colors.red),
//                 ),
//                 const SizedBox(width: 10),
//                 FloatingActionButton(
//                   backgroundColor: Colors.blueAccent,
//                   onPressed: () {
//                     if (locationMarkers.length < 2) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Tap on map to add more locations'),
//                         ),
//                       );
//                     } else {
//                       getCoordinates();
//                     }
//                   },
//                   child: const Icon(Icons.route, color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   double _calculateDistance() {
//     if (routePoints.length < 2) return 0.0;

//     const Distance distance = Distance();
//     double totalDistance = 0.0;

//     for (int i = 1; i < routePoints.length; i++) {
//       totalDistance += distance(routePoints[i - 1], routePoints[i]);
//     }

//     return totalDistance / 1000; // Convert to kilometers
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:project/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _MapScreenState();
}

class _MapScreenState extends State<UserPage> {
  List<LatLng> routePoints = [];
  List<LatLng> currentSegmentPoints = [];
  List<LatLng> locationMarkers = [];
  bool isLoading = false;
  bool showDummyIcons = false;
  final MapController _mapController = MapController();

  TextEditingController _destinationController = TextEditingController();
  String _destination = "";

  List<LatLng> dummyLocations = [
    LatLng(12.9758527, 79.137239),
    LatLng(12.958831, 79.137249),
    LatLng(12.975635, 79.093810),
  ];

  LatLng destination = LatLng(12.972222, 79.138333);
  List<List<LatLng>> polylines = [];

  @override
  void initState() {
    super.initState();
    locationMarkers.add(destination);
  }

  void _onDestinationPressed() {
    setState(() {
      _destination = _destinationController.text;
      showDummyIcons = true;
      _fetchRoutesForAutos();
    });

    print("Destination: $_destination");
  }

  Future<void> _fetchRoutesForAutos() async {
    polylines.clear();

    for (LatLng autoLocation in dummyLocations) {
      List<LatLng> route = await _fetchRoute(autoLocation, destination);
      setState(() {
        polylines.add(route);
      });
    }
  }

  Future<List<LatLng>> _fetchRoute(LatLng start, LatLng end) async {
    try {
      String startCoords =
          "${start.longitude.toStringAsFixed(6)},${start.latitude.toStringAsFixed(6)}";
      String endCoords =
          "${end.longitude.toStringAsFixed(6)},${end.latitude.toStringAsFixed(6)}";

      var response = await http.get(getRouteUrl(startCoords, endCoords));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        final coordinates = data['features'][0]['geometry']['coordinates'];

        if (coordinates is List && coordinates.isNotEmpty) {
          return coordinates
              .map((p) => LatLng(
                    double.parse(p[1].toString()),
                    double.parse(p[0].toString()),
                  ))
              .toList();
        }
      }
    } catch (e) {
      print("Error fetching route: $e");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                zoom: 15,
                center: locationMarkers.first,
                interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.app',
                  maxZoom: 19,
                ),

                MarkerLayer(
                  markers: [
                    ...locationMarkers.map((point) => Marker(
                          point: point,
                          width: 50,
                          height: 50,
                          builder: (context) => Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 50,
                          ),
                        )),

                    if (showDummyIcons)
                      ...dummyLocations.map((coord) => Marker(
                            point: coord,
                            width: 50,
                            height: 50,
                            builder: (context) =>
                                Image.asset('assets/images/autowala_logo.png'),
                          )),
                  ],
                ),

                if (polylines.isNotEmpty)
                  PolylineLayer(
                    polylineCulling: false,
                    polylines: polylines
                        .map((route) => Polyline(
                              points: route,
                              color: Colors.blue,
                              strokeWidth: 4.0,
                            ))
                        .toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
