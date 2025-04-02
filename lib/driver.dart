
// import 'package:flutter/material.dart';

// class DriverLoginPage extends StatefulWidget {
//   @override
//   _DriverLoginPageState createState() => _DriverLoginPageState();
// }

// class _DriverLoginPageState extends State<DriverLoginPage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   final TextEditingController _autoNumberController = TextEditingController();

//   void _submit() {
//     String name = _nameController.text;
//     String age = _ageController.text;
//     String autoNumber = _autoNumberController.text;
//     print("Name: $name, Age: $age, Auto Number: $autoNumber");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Driver Login')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'DriverName'),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _ageController,
//               decoration: InputDecoration(labelText: 'Age'),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _autoNumberController,
//               decoration: InputDecoration(labelText: 'Auto Number'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _submit,
//               child: Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Functionalities/location_detector.dart';
import 'Functionalities/saving_userID.dart';
class DriverLoginPage extends StatefulWidget {
  const DriverLoginPage({super.key});
  @override
  _DriverLoginPageState createState() => _DriverLoginPageState();
}

class _DriverLoginPageState extends State<DriverLoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _autoNumberController = TextEditingController();
  LocationService driver_loc= LocationService();
// URL of your Flask backend
  final String apiUrl = 'http://192.168.231.239:5000/add_driver';  // Replace with your Flask server's IP if testing on a device

  // Function to send data to the Flask backend
  Future<void> _submit() async {
    String name = _nameController.text;
    String age = _ageController.text;
    String autonumber = _autoNumberController.text;
    double lat=0.0;
    double long=0.0;
    await saveData('id', '1');
    await saveData('user_type', 'driver');
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
          'autonumber' : autonumber,
          'lat': lat,
          'long': long
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
  // void _submit() {
  //   String name = _nameController.text;
  //   String age = _ageController.text;
  //   String autoNumber = _autoNumberController.text;
  //   print("Name: $name, Age: $age, Auto Number: $autoNumber");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff918e97),
      appBar: AppBar(
        title: const Text(
          'Driver Login',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Bold app bar text
            fontSize: 20, // Slightly larger app bar title
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1D1927),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              style: const TextStyle(
                fontSize: 20, // Increased font size
              ),
              decoration: const InputDecoration(
                labelText: 'Driver Name',
                labelStyle: TextStyle(
                  fontSize: 20, // Increased label size
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _ageController,
              style: const TextStyle(
                fontSize: 20, // Increased font size
              ),
              decoration: const InputDecoration(
                labelText: 'Age',
                labelStyle: TextStyle(
                  fontSize: 20, // Increased label size
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _autoNumberController,
              style: const TextStyle(
                fontSize: 20, // Increased font size
              ),
              decoration: const InputDecoration(
                labelText: 'Auto Number',
                labelStyle: TextStyle(
                  fontSize: 20, // Increased label size
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D1927),
                minimumSize: const Size(150, 50), // Reduced button size
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20, // Increased font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
