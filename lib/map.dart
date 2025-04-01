import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:project/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<LatLng> routePoints = []; // All points that form the complete route
  List<LatLng> currentSegmentPoints = []; // Points for the current segment being fetched
  List<LatLng> locationMarkers = []; // All locations added by the user
  bool isLoading = false;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // Set default start point with precise coordinates
    locationMarkers.add(const LatLng(12.972222, 79.138333));
  }

  Future<void> getCoordinates() async {
    if (locationMarkers.length < 2) return;
    
    setState(() {
      isLoading = true;
      currentSegmentPoints = []; // Clear current segment while loading
    });
    
    try {
      // Get the last two locations to draw the segment between them
      final startPoint = locationMarkers[locationMarkers.length - 2];
      final endPoint = locationMarkers.last;
      
      // Format coordinates with higher precision
      final startCoords = "${startPoint.longitude.toStringAsFixed(6)},${startPoint.latitude.toStringAsFixed(6)}";
      final endCoords = "${endPoint.longitude.toStringAsFixed(6)},${endPoint.latitude.toStringAsFixed(6)}";
      
      var response = await http.get(getRouteUrl(startCoords, endCoords));
      
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        final coordinates = data['features'][0]['geometry']['coordinates'];
        
        // Verify we received valid coordinates
        if (coordinates is List && coordinates.isNotEmpty) {
          setState(() {
            currentSegmentPoints = coordinates
                .map((p) => LatLng(
                      double.parse(p[1].toString()),
                      double.parse(p[0].toString()),
                    ))
                .toList();
            
            // Combine all segments to form the complete route
            if (routePoints.isNotEmpty) {
              // Remove the last point to avoid duplicates when combining
              routePoints.removeLast();
            }
            routePoints.addAll(currentSegmentPoints);
          });
          
          // Adjust map view to show the entire route
          _adjustMapView();
        }
      } else {
        throw Exception('Failed to load route: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _adjustMapView() {
    if (routePoints.isEmpty || locationMarkers.isEmpty) return;
    
    // Create bounds that include all markers and the route
    final bounds = LatLngBounds.fromPoints([
      ...locationMarkers,
      ...routePoints,
    ]);
    
    // Animate map to show the entire route with some padding
    _mapController.fitBounds(
      bounds,
      options: FitBoundsOptions(
        padding: EdgeInsets.all(40),
      ),
    );
  }

  void _handleTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      locationMarkers.add(latlng);
    });
    
    // Show the exact coordinates in a snackbar for debugging
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added location: ${latlng.latitude.toStringAsFixed(6)}, ${latlng.longitude.toStringAsFixed(6)}'),
        duration: Duration(seconds: 2),
      ),
    );
    
    // Automatically fetch route if we have at least 2 points
    if (locationMarkers.length >= 2) {
      getCoordinates();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              zoom: 15,
              center: locationMarkers.first,
              onTap: _handleTap,
              interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app',
                maxZoom: 19, // Higher max zoom for better precision
              ),
              MarkerLayer(
                markers: locationMarkers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final point = entry.value;
                  return Marker(
                    point: point,
                    width: 80,
                    height: 80,
                    builder: (context) => Icon(
                      Icons.location_pin,
                      color: index == 0 
                          ? Colors.green 
                          : (index == locationMarkers.length - 1 
                              ? Colors.red 
                              : Colors.blue),
                      size: 45,
                    ),
                  );
                }).toList(),
              ),
              PolylineLayer(
                polylineCulling: false,
                polylines: [
                  if (routePoints.isNotEmpty)
                    Polyline(
                      points: routePoints,
                      color: Colors.blue.withOpacity(0.7),
                      strokeWidth: 6,
                    ),
                ],
              ),
            ],
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            top: 40,
            left: 20,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {
                if (locationMarkers.isNotEmpty) {
                  _mapController.move(locationMarkers.first, 15);
                }
              },
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (locationMarkers.length >= 2 && routePoints.isNotEmpty)
            FloatingActionButton(
              heroTag: 'distance',
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {
                final distance = _calculateDistance();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Total distance: ${distance.toStringAsFixed(2)} km')),
                );
              },
              child: const Icon(Icons.straighten, color: Colors.blue),
            ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'clear',
            mini: true,
            backgroundColor: Colors.white,
            onPressed: () {
              setState(() {
                locationMarkers = [locationMarkers.first]; // Keep only the first point
                routePoints = [];
                currentSegmentPoints = [];
              });
            },
            child: const Icon(Icons.clear, color: Colors.red),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            onPressed: () {
              if (locationMarkers.length < 2) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tap on map to add more locations')));
              } else {
                getCoordinates();
              }
            },
            child: const Icon(Icons.route, color: Colors.white),
          ),
        ],
      ),
    );
  }

  double _calculateDistance() {
    if (routePoints.length < 2) return 0.0;
    
    const Distance distance = Distance();
    double totalDistance = 0.0;
    
    for (int i = 1; i < routePoints.length; i++) {
      totalDistance += distance(routePoints[i-1], routePoints[i]);
    }
    
    return totalDistance / 1000; // Convert to kilometers
  }
}