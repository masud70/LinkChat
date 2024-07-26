import 'package:flutter/material.dart';
import 'package:link_chat/screens/auth/login_screen.dart';
import 'package:link_chat/screens/auth/signup_screen.dart';
import 'package:link_chat/screens/home.dart';
import 'package:link_chat/screens/message_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Link',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 220, 255, 255),
        ),
        primaryColor: const Color.fromRGBO(170, 0, 0, 1),
        dialogBackgroundColor: const Color.fromRGBO(255, 220, 220, 1),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        useMaterial3: true,
      ),
      initialRoute: Home.routeName,
      routes: {
        LoginScreen.routeName: (ctx) => const LoginScreen(),
        SignupScreen.routeName: (ctx) => const SignupScreen(),
        Home.routeName: (ctx) => const Home(),
        MessageScreen.routeName: (ctx) => const MessageScreen(),
      },
    );
  }
}
