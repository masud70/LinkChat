import 'package:flutter/material.dart';
import 'package:link/providers/auth_provider.dart';
import 'package:link/screens/home.dart';
import 'package:link/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:link/screens/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _navigate(ctx) async {
    try {
      final isLoggedIn = await Provider.of<Auth>(context).checkLogin();

      if (isLoggedIn) {
        Navigator.of(ctx).pushReplacementNamed(Home.routeName);
      } else {
        Navigator.of(ctx).pushReplacementNamed(LoginScreen.routeName);
      }
    } catch (e) {
      Util.i(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    _navigate(context);

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
