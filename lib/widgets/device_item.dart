import 'package:flutter/material.dart';

class DeviceItem extends StatelessWidget {
  final Map<String, String> device;
  const DeviceItem({required this.device, super.key});

  @override
  Widget build(BuildContext context) {
    return Text('${device['name']}');
  }
}
