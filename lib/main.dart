import 'package:flutter/material.dart';
import 'user.dart';
import 'driver.dart';
import 'map.dart';
import 'Functionalities/location_detector.dart';
enum UserType{
  user,
  driver,
}
LocationService locationService = LocationService(); // Initialize globally



void main()  {
  //locationService.startTracking(cont:true);
  // Check permissions and start tracking
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserLoginPage()),
                );
              },
              child: Text('User Login'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DriverLoginPage()),
                );
              },
              child: Text('Driver Login'),
            ),
            SizedBox(height: 20), // Add spacing
            ElevatedButton( // Add this new button
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage()),
                );
              },
              child: Text('View Map'),
            ),
            ElevatedButton(
              onPressed: () {
                locationService.startTracking(cont: true); // Start continuous tracking
                print('Started continuous location tracking and sending to backend.');
              },
              child: Text('Start Continuous Tracking'),
            ),
          ],
        ),
      ),
    );
  }
}