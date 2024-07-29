import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:link/controllers/auth_controller.dart';
import 'package:link/models/user.dart';
import 'package:link/providers/auth_provider.dart';
import 'package:link/screens/auth/login_screen.dart';
import 'package:link/screens/auth/signup_screen.dart';
import 'package:link/screens/home.dart';
import 'package:link/screens/message_screen.dart';
import 'package:link/screens/splash_screen.dart';
import 'package:link/services/background_service.dart';
import 'package:link/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<NearbyService?> initializeNearbyService() async {
  try {
    NearbyService nearbyService = NearbyService();
    String deviceName = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    if (username != null) {
      User? user = await AuthController().getUserByUsername(username);
      deviceName = user!.name;
    } else {
      deviceName = 'Anonymous User';
    }

    await nearbyService.init(
      serviceType: 'mpconn',
      deviceName: deviceName,
      strategy: Strategy.P2P_CLUSTER,
      callback: (isRunning) async {
        if (isRunning) {
          await nearbyService.stopAdvertisingPeer();
          await nearbyService.stopBrowsingForPeers();
          await Future.delayed(const Duration(microseconds: 200));
          await nearbyService.startAdvertisingPeer();
          await nearbyService.startBrowsingForPeers();
        }
      },
    );
    return nearbyService;
  } catch (e) {
    Util.e(e);
    return null;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initBackgroundService();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
      ],
      child: MaterialApp(
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
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (ctx) => const SplashScreen(),
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          SignupScreen.routeName: (ctx) => const SignupScreen(),
          Home.routeName: (ctx) => const Home(),
          MessageScreen.routeName: (ctx) => const MessageScreen(),
        },
      ),
    );
  }
}
