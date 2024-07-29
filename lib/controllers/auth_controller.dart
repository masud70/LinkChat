import 'package:link/db/db.dart';
import 'package:link/models/user.dart';
import 'package:link/services/background_service.dart';
import 'package:link/util/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final DB _db = DB();

  Future<void> signupUser(
    String name,
    String username,
    String password,
    String confirmPassword,
  ) async {
    if (password != confirmPassword) {
      throw Exception('Passwords do not match');
    }

    final position = await Util.getCurrentLocation();
    if (position == null) {
      throw Exception('Failed to get location');
    }

    User user = User(
      name: name,
      username: username,
      password: password,
      userType: 'author',
      lat: position.latitude,
      lng: position.longitude,
      timestamp: DateTime.now().toIso8601String(),
    );

    bool connected = await _db.connect();
    if (connected) {
      await _db.insertUser(user);
      await _db.close();
    } else {
      throw Exception('Database connection failed');
    }
  }

  Future<User?> loginUser(String username, String password) async {
    bool connected = await _db.connect();
    if (!connected) {
      throw Exception('Database connection failed');
    }

    User? user = await _db.getUserByUsername(username);
    await _db.close();

    if (user != null && user.password == password) {
      await initBackgroundService();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setInt('userId', user.id!);
      return user;
    } else {
      throw Exception('Invalid username or password');
    }
  }

  Future<User?> getUserByUsername(String username) async {
    try {
      User? user = await _db.getUserByUsername(username);

      if (user != null) {
        return user;
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('An error occurred: ${e.toString()}');
    }
  }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userId');
  }

  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
