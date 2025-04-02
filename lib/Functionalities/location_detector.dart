import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

class LocationService {
  Stream<Position>? positionStream;
  double latitude=0.0;
  double longitude=0.0;
  LocationService() {
    checkPermissionsAndStartTracking();
  }
  Future<void> requestLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    // Check the current permission status
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission if it is denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle the case where permissions are permanently denied
      print('Location permissions are permanently denied.');
      return;
    }

    // If permissions are granted
    print('Location permissions are granted.');
  }
  Future<void> checkPermissionsAndStartTracking() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return;
    }

    // Start tracking location if permissions are granted
    startTracking();
  }

  void startTracking({bool cont=false}) {
    // Set up the location stream
    positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0, // Minimum distance for updates (in meters)
      ),
    );

    positionStream?.listen((Position? position) {
      if (position != null) {
        latitude = position.latitude;
        longitude = position.longitude;
        if(cont)
          sendLocationToBackend(latitude, longitude);
        print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
        // Additional logic, e.g., save to database, can be added here
      }
    });
  }
  Future<void> sendLocationToBackend(double latitude, double longitude) async {
    const String backendUrl = "http://192.168.34.53:5000/update_location"; // Replace with your backend URL

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode( {
          'lat': latitude.toString(),
          'long': longitude.toString(),
        }),
      );

      if (response.statusCode == 200) {
        print("Location sent to backend successfully.");
      } else {
        print("Failed to send location to backend: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending location to backend: $e");
    }
  }
}

