// import 'package:flutter/material.dart';

// class UserLoginPage extends StatefulWidget {
//   @override
//   _UserLoginPageState createState() => _UserLoginPageState();
// }

// class _UserLoginPageState extends State<UserLoginPage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();

//   void _submit() {
//     String name = _nameController.text;
//     String age = _ageController.text;
//     print("Name: $name, Age: $age");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('User Login')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'UserName'),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _ageController,
//               decoration: InputDecoration(labelText: 'Age'),
//               keyboardType: TextInputType.number,
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
import 'Functionalities/location_detector.dart'; // Import your location service

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});
  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
<<<<<<< HEAD
  LocationService user_loc= LocationService(); // Initialize location service
  // URL of your Flask backend
  final String apiUrl = 'http://172.17.214.224:5000/add_user';  // Replace with your Flask server's IP if testing on a device
=======
  final TextEditingController _genderController = TextEditingController();

  // URL of your Flask backend
  final String apiUrl = 'http://localhost:5000/add_user';  // Replace with your Flask server's IP if testing on a device
>>>>>>> bca4bcb8467a83e636b36c3fe78248e09a0e22f2

  // Function to send data to the Flask backend
  Future<void> _submit() async {
    String name = _nameController.text;
    String age = _ageController.text;
<<<<<<< HEAD
    double long=user_loc.longitude;
    double lat=user_loc.latitude;
     // Get the last known location
=======
    String gender = _genderController.text;

>>>>>>> bca4bcb8467a83e636b36c3fe78248e09a0e22f2
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
<<<<<<< HEAD
          'long': long,
          'lat': lat,
=======
          'gender' : gender,
>>>>>>> bca4bcb8467a83e636b36c3fe78248e09a0e22f2
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
      backgroundColor: const Color(0xff918e97),
      appBar: AppBar(
        title: const Text(
          'User Login',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              style: const TextStyle(
                fontSize: 20, // Increased font size
              ),
              decoration: const InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(
                  fontSize: 20, // Increased label size
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 30),
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
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _genderController,
              style: const TextStyle(
                fontSize: 20, // Increased font size
              ),
              decoration: const InputDecoration(
                labelText: 'Gender',
                labelStyle: TextStyle(
                  fontSize: 20, // Increased label size
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 30),
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
