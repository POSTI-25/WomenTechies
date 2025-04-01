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

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});
  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  void _submit() {
    String name = _nameController.text;
    String age = _ageController.text;
    String gender = _genderController.text;
    debugPrint("Name: $name, Age: $age, Gender: $gender");
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
