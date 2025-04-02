import 'package:shared_preferences/shared_preferences.dart';
//import 'package:http/http.dart' as http;
Future<bool> saveDataIfKeyDoesNotExist(String key,String type/*, String value*/) async {
  final prefs = await SharedPreferences.getInstance();

  // Check if the key already exists
  if (prefs.containsKey(key)|| prefs.containsKey(type)) {
    
    print('Key "$key" already exists with value: ${prefs.getString(key)}');
    return true;
  } else {
    // Save the data if the key does not exist
    // await prefs.setString(key, '1');
    // await prefs.setString(type, 'user'); // Assuming 'user' is the value you want to save
    return false;
    // await prefs.setString(key, value);
    // print('Data saved: $key = $value');
  }
}
Future<void> saveData(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value); // Saves the value associated with the key
  print('Data saved: $key = $value');
}
Future<String?> getData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}
Future<void> removeData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(key); // Removes the value associated with the key
  print('Data for key "$key" has been removed.');
}
