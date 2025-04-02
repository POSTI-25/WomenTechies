import 'package:flutter/material.dart';
import 'user.dart';
import 'driver.dart';
//import 'map.dart';
import 'driver_main_page.dart';
import 'user_main_page.dart';
//import 'driver_main_page.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff918e97),
      appBar: AppBar(
        title: const Text(
          'Welcome to AutoWala',
          style: TextStyle(
            color: Color(0xffffffff),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1D1927),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/autowala_logo.png', // Path to your image
              height: 150, // Height of the image
              width: 150, // Width of the image
              fit: BoxFit
                  .contain, // How the image should be inscribed into the space
              semanticLabel: 'AutoWala Logo', // Accessibility label
            ),
            const Text(
              'Make Profile As :',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Color(0xFF1D1927),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 45),
            
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserLoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                backgroundColor: const Color(0xFF1D1927),
              ),
              child: const Text(
                'Passenger',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white, // White text color added
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DriverLoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                backgroundColor: const Color(0xFF1D1927),
              ),
              child: const Text(
                'Driver',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white, // White text color added
                ),
              ),
            ),
            SizedBox(height: 20), // Add spacing
          
            ElevatedButton( // Add this new button
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserMainPage()),
                );
              },
              child: Text('View Map as User'),
            ),
            
            SizedBox(height: 20), // Add spacing
            
            ElevatedButton( // Add this new button
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DriverMainPage()),
                );
              },
              child: Text('View Map as Driver'),
            ),

          ],
        ),
      ),
    );
  }
}