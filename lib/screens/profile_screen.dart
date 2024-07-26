import 'package:flutter/material.dart';
import 'package:link_chat/widgets/device_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<Map<String, String>> _devices = [
    {'name': 'Device 1', 'id': '1234'},
    {'name': 'Device 2', 'id': '1234'},
    {'name': 'Device 3', 'id': '1234'},
    {'name': 'Device 4', 'id': '1234'},
    {'name': 'Device 5', 'id': '1234'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Connected Devices:',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: double.infinity,
                height: 200,
                child: ListView.builder(
                  itemCount: _devices.length,
                  itemBuilder: (BuildContext ctx, int idx) {
                    return DeviceItem(device: _devices[idx]);
                  },
                ),
              )
            ],
          )),
    );
  }
}
