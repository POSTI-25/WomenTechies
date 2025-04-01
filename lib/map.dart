import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<LatLng> routePoints = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getCoordinates();
  }

  Future<void> getCoordinates() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.get(getRouteUrl("12.969193,79.155968", "12.972222,79.138333"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> coordinates = data['features'][0]['geometry']['coordinates'];
        
        // Convert the coordinates to LatLng objects (note: API returns [longitude, latitude])
        List<LatLng> points = coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();

        setState(() {
          routePoints = points;
        });
      }
    } catch (e) {
      print("Error fetching route: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenStreetMap'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: screenSize.width,
            height: screenSize.height * 0.8,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(12.976128, 79.1642112),
                zoom: 13.0,
              ),
              nonRotatedChildren: [
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                    ),
                  ],
                ),
              ],
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                  maxZoom: 19,
                ),
                // Add the polyline layer if we have route points
                if (routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        color: Colors.blue.withOpacity(0.7),
                        strokeWidth: 4,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(12.969193, 79.155968),
                      width: 80,
                      height: 80,
                      builder: (context) => IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.location_on),
                        color: Colors.green,
                        iconSize: 45,
                      ),
                    ),
                    Marker(
                      point: LatLng(12.972222, 79.138333),
                      width: 80,
                      height: 80,
                      builder: (context) => IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.location_on),
                        color: Colors.red,
                        iconSize: 45,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}