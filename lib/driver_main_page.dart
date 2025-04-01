import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:project/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EnhancedMapScreen extends StatefulWidget {
  const EnhancedMapScreen({super.key});

  @override
  State<EnhancedMapScreen> createState() => _EnhancedMapScreenState();
}

class _EnhancedMapScreenState extends State<EnhancedMapScreen> {
  List<LatLng> routePoints = [];
  List<LatLng> currentSegmentPoints = [];
  List<LatLng> acceptedLocations = [];
  LatLng? pendingLocation;
  bool isLoading = false;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    acceptedLocations.add(const LatLng(12.972222, 79.138333));
  }

  Future<void> getCoordinates() async {
    if (acceptedLocations.length < 2) return;
    
    setState(() {
      isLoading = true;
      currentSegmentPoints = [];
    });
    
    try {
      final startPoint = acceptedLocations[acceptedLocations.length - 2];
      final endPoint = acceptedLocations.last;
      
      final startCoords = "${startPoint.longitude.toStringAsFixed(6)},${startPoint.latitude.toStringAsFixed(6)}";
      final endCoords = "${endPoint.longitude.toStringAsFixed(6)},${endPoint.latitude.toStringAsFixed(6)}";
      
      var response = await http.get(getRouteUrl(startCoords, endCoords));
      
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        final coordinates = data['features'][0]['geometry']['coordinates'];
        
        if (coordinates is List && coordinates.isNotEmpty) {
          setState(() {
            currentSegmentPoints = coordinates
                .map((p) => LatLng(
                      double.parse(p[1].toString()),
                      double.parse(p[0].toString()),
                    ))
                .toList();
            
            if (routePoints.isNotEmpty) {
              routePoints.removeLast();
            }
            routePoints.addAll(currentSegmentPoints);
          });
          
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
    if (routePoints.isEmpty || acceptedLocations.isEmpty) return;
    
    final bounds = LatLngBounds.fromPoints([
      ...acceptedLocations,
      ...routePoints,
      if (pendingLocation != null) pendingLocation!,
    ]);
    
    _mapController.fitBounds(
      bounds,
      options: const FitBoundsOptions(padding: EdgeInsets.all(40)),
    );
  }

  void _handleTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      pendingLocation = latlng;
    });
  }

  void _acceptLocation() {
    if (pendingLocation == null) return;
    
    setState(() {
      acceptedLocations.add(pendingLocation!);
      pendingLocation = null;
    });
    
    if (acceptedLocations.length >= 2) {
      getCoordinates();
    }
  }

  void _declineLocation() {
    setState(() {
      pendingLocation = null;
    });
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
              center: acceptedLocations.first,
              onTap: _handleTap,
              interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app',
                maxZoom: 19,
              ),
              MarkerLayer(
                markers: [
                  ...acceptedLocations.asMap().entries.map((entry) {
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
                            : (index == acceptedLocations.length - 1 
                                ? Colors.red 
                                : Colors.blue),
                        size: 45,
                      ),
                    );
                  }),
                  if (pendingLocation != null)
                    Marker(
                      point: pendingLocation!,
                      width: 80,
                      height: 80,
                      builder: (context) => const Icon(
                        Icons.location_pin,
                        color: Colors.orange,
                        size: 45,
                      ),
                    ),
                ],
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
            const Center(child: CircularProgressIndicator()),
          Positioned(
            top: 40,
            left: 20,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {
                if (acceptedLocations.isNotEmpty) {
                  _mapController.move(acceptedLocations.first, 15);
                }
              },
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),
          if (pendingLocation != null)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: _buildConfirmationOverlay(),
                ),
              ),
        ],
      ),
      floatingActionButton: acceptedLocations.length >= 2 && routePoints.isNotEmpty
          ? FloatingActionButton(
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
            )
          : null,
    );
  }

Widget _buildConfirmationOverlay() {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 300), // Set your desired max width
    child: Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Accept User Request ?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _declineLocation,
                  child: const Text('Decline'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _acceptLocation,
                  child: const Text('Accept'),
                ),
              ],
            ),
          ],
        ),
      ),
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
    
    return totalDistance / 1000;
  }
}