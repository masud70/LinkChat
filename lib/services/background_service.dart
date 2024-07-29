import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:link/controllers/message_controller.dart';
import 'package:link/main.dart';
import 'package:link/util/utils.dart';

NearbyService? nearbyService;

Future<void> initBackgroundService() async {
  try {
    nearbyService = await initializeNearbyService();
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );

    await service.startService();
  } catch (e) {
    Util.i(e);
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  try {
    StreamSubscription? recSub;
    List<Device> devices = [];

    service.on('test').listen((event) async {
      Util.i(event!['key']);
    });

    service.on('setNearby').listen((event) {
      Util.e('Dummy ERROE!');
      Util.i(event);
    });

    service.on('sendMessage').listen((event) async {
      String deviceId = event!['deviceId'] as String;
      String content = event['content'] as String;
      nearbyService!.sendMessage(deviceId, content);
      try {
        await nearbyService!.sendMessage(deviceId, content);
        service.invoke('sentMessage',
            {'status': 'success', 'message': 'Message sent successfully!'});
      } catch (e) {
        service.invoke('sentMessage',
            {'status': 'error', 'message': 'Failed to send message.'});
      }
    });

    service.on('getDeviceList').listen((event) async {
      Util.i(devices.length);
    });

    service.on('stopService').listen((event) async {
      recSub!.cancel();
      await service.stopSelf();
    });

    nearbyService!.stateChangedSubscription(callback: (devicesList) {
      devices.clear();
      devicesList.map((element) {
        Util.i("Id: ${element.deviceId} | Name: ${element.deviceName}");
        devices.add(element);
      });
    });

    recSub = nearbyService!.dataReceivedSubscription(callback: (data) async {
      MessageController mc = MessageController(nearbyService: nearbyService);
      await mc.handleReceivedMessage(data);
    });
  } catch (e) {
    Util.i('Error: $e');
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}
