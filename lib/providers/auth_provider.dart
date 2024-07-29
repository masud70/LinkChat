import 'package:flutter/material.dart';
import 'package:link/db/db.dart';
import 'package:link/models/user.dart';
import 'package:link/screens/auth/login_screen.dart';
import 'package:link/screens/home.dart';
import 'package:link/util/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  final DB _db = DB();
  User? user;
  bool isLoggedIn = false;

  Auth({this.user});

  User? get getUser {
    return user;
  }

  void setUser(User u) {
    user = u;
    notifyListeners();
  }

  void clearUser() {
    user = null;
    notifyListeners();
  }

  Future<bool> checkLogin() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? username = prefs.getString('username');

      if (username == null) {
        throw Exception('No saved username founed.');
      }

      final User? userData = await _db.getUserByUsername(username);
      if (userData == null) {
        throw Exception('User not found in database.');
      }
      isLoggedIn = true;
      setUser(userData);
      return true;
    } catch (error) {
      Util.i(error.toString());
      return false;
    }
  }

  void signIn(context, String username, String password) async {
    try {
      final User? user = await _db.getUserByUsername(username);
      if (user == null || user.password != password) {
        throw Exception('Username or password is incorrect.');
      }
      setUser(user);
      isLoggedIn = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', user.username);

      Util.toast(context, 'Login successful!');
      Navigator.of(context).pushReplacementNamed(Home.routeName);
    } catch (error) {
      Util.toast(context, error.toString());
      Util.i('Login failed.');
    }
  }

  void signUp({context, required User userData}) async {
    try {
      final position = await Util.getCurrentLocation();
      if (position == null) {
        throw Exception('Failed to get location');
      }
      final User? u = await _db.getUserByUsername(userData.username);

      if (u != null) {
        throw Exception('Username already exits.');
      }

      userData.lat = position.latitude;
      userData.lng = position.longitude;
      userData.id = DateTime.now().millisecondsSinceEpoch;

      final id = await _db.insertUser(userData);

      if (id == null || id == 0) {
        throw Exception('Signup failed.');
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', userData.username);

      Navigator.of(context).pushReplacementNamed(Home.routeName);
      Util.toast(context, 'Signup successful!');
    } catch (error) {
      Util.toast(context, error.toString());
    }
  }

  void signOut(context) async {
    isLoggedIn = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    Util.toast(context, 'Logout successful!');
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    clearUser();
  }
}
