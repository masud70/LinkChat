import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:link/controllers/auth_controller.dart';
import 'package:link/models/user.dart';
import 'package:link/screens/message_screen.dart';
import 'package:link/util/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DeviceType { advertiser, browser }

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';
  final DeviceType deviceType;
  const SearchScreen({this.deviceType = DeviceType.browser, super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Device> devices = [];
  List<Device> connectedDevices = [];
  late NearbyService nearbyService;
  late StreamSubscription subscription;
  late StreamSubscription receivedDataSubscription;
  final Util u = Util();

  bool isInit = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initNearbyService();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(193, 221, 255, 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Found: ${devices.length} ${devices.length > 1 ? 'users' : 'user'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 91, 209, 95),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: InkWell(
                  onTap: initNearbyService,
                  child: Row(
                    children: [
                      Text(
                        isLoading ? 'Searching ' : 'Search ',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      isLoading
                          ? Util.loader()
                          : const Icon(
                              Icons.update_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 500,
          child: ListView.builder(
            itemCount: getItemCount(),
            itemBuilder: (context, index) {
              final device = devices[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: const Color.fromARGB(205, 204, 223, 201),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => {
                          if (device.state == SessionState.connected)
                            {
                              Navigator.pushNamed(
                                  context, MessageScreen.routeName,
                                  arguments: {
                                    device: device,
                                    nearbyService: nearbyService,
                                  })
                            }
                          else
                            {Util.toast(context, 'Connect the user first.')}
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              device.deviceName,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              getStateName(device.state),
                              style: TextStyle(
                                color: getStateColor(device.state),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Request connect
                    InkWell(
                      onTap: () {
                        _onButtonClicked(device);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        padding: const EdgeInsets.all(8.0),
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: getButtonColor(device.state),
                        ),
                        child: Center(
                          child: device.state != SessionState.connected &&
                                  device.state != SessionState.notConnected
                              ? Util.loader()
                              : Text(
                                  getButtonStateName(device.state),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void initNearbyService() async {
    setState(() {
      isLoading = true;
    });

    // subscription.cancel();
    // receivedDataSubscription.cancel();
    // nearbyService.stopBrowsingForPeers();
    // nearbyService.stopAdvertisingPeer();

    nearbyService = NearbyService();

    String deviceName = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    if (username != null) {
      User? user = await AuthController().getUserByUsername(username);
      deviceName = user!.name;
    } else {
      deviceName = 'Anonymous User';
    }

    try {
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
              setState(() {
                isInit = true;
              });
            }
          });

      subscription =
          nearbyService.stateChangedSubscription(callback: (devicesList) {
        devicesList.map((element) {}).toList();
        setState(() {
          devices = devicesList;
        });
      });

      receivedDataSubscription =
          nearbyService.dataReceivedSubscription(callback: (data) {});
    } catch (e) {
      Util.i("Error initializing nearby service: $e");
    }
  }

  String getStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return "disconnected";
      case SessionState.connecting:
        return "waiting";
      default:
        return "connected";
    }
  }

  String getButtonStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return "Connect";
      case SessionState.connecting:
        return "Connecting";
      default:
        return "Disconnect";
    }
  }

  Color getStateColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return Colors.black;
      case SessionState.connecting:
        return Colors.grey;
      default:
        return Colors.green;
    }
  }

  Color getButtonColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return const Color.fromARGB(255, 94, 178, 97);
      case SessionState.connecting:
        return const Color.fromARGB(255, 124, 145, 124);
      default:
        return Colors.red;
    }
  }

  _onTabItemListener(Device device) {
    if (device.state == SessionState.connected) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            final myController = TextEditingController();
            return AlertDialog(
              title: const Text("Send message"),
              content: TextField(controller: myController),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("Send"),
                  onPressed: () {
                    nearbyService.sendMessage(
                        device.deviceId, myController.text);
                    myController.text = '';
                  },
                )
              ],
            );
          });
    }
  }

  int getItemCount() {
    if (widget.deviceType == DeviceType.advertiser) {
      return connectedDevices.length;
    } else {
      return devices.length;
    }
  }

  _onButtonClicked(Device device) {
    switch (device.state) {
      case SessionState.notConnected:
        nearbyService.invitePeer(
          deviceID: device.deviceId,
          deviceName: device.deviceName,
        );
        break;
      case SessionState.connected:
        nearbyService.disconnectPeer(deviceID: device.deviceId);
        break;
      case SessionState.connecting:
        break;
    }
  }
}
