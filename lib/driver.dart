
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

class DriverLoginPage extends StatefulWidget {
  const DriverLoginPage({super.key});
  @override
  _DriverLoginPageState createState() => _DriverLoginPageState();
}

class _DriverLoginPageState extends State<DriverLoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _autoNumberController = TextEditingController();

  void _submit() {
    String name = _nameController.text;
    String age = _ageController.text;
    String autoNumber = _autoNumberController.text;
    print("Name: $name, Age: $age, Auto Number: $autoNumber");
  }

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
              controller: _nameController,
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
              controller: _nameController,
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
