import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Functionalities/location_detector.dart'; // Import your location service

class UserLoginPage extends StatefulWidget {
  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  LocationService user_loc= LocationService(); // Initialize location service
  // URL of your Flask backend
  final String apiUrl = 'http://172.17.214.224:5000/add_user';  // Replace with your Flask server's IP if testing on a device

  // Function to send data to the Flask backend
  Future<void> _submit() async {
    String name = _nameController.text;
    String age = _ageController.text;
    double long=user_loc.longitude;
    double lat=user_loc.latitude;
     // Get the last known location
    // Validate input
    if (name.isEmpty || age.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter both name and age")));
      return;
    }

    // Send POST request
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'age': age,
          'long': long,
          'lat': lat,
        }),
      );

      if (response.statusCode == 200) {
        // Success
        print('User data sent successfully!');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data sent successfully!')));
      } else {
        // Handle error
        print('Error: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send data')));
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to connect to the server')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'UserName'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
