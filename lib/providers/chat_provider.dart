import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

class Chat with ChangeNotifier {
  NearbyService? nearbyService;

  Chat({required this.nearbyService});

  NearbyService? get ns {
    return nearbyService;
  }
}
