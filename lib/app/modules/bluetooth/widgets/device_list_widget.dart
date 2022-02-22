import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/app/modules/bluetooth/bluetooth_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class DeviceList extends StatefulWidget {
  late List<DiscoveredDevice> discoveredDevice;
  DeviceList({
    Key? key,
    required this.discoveredDevice,
  }) : super(key: key);

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  BluetoothStore store = Modular.get();

  @override
  void initState() {
    store.scanStart(
      store.serviceIds,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DiscoveredDevice>>(
      stream: Stream.periodic(const Duration(milliseconds: 500), (_) {
        return store.state;
      }),
      initialData: const [],
      builder: (context, snapshot) {
        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: snapshot.data!
              .map(
                (device) => ListTile(
                  leading: const Icon(
                    Icons.bluetooth,
                  ),
                  title: Text(device.name),
                  subtitle: Text(device.rssi.toString()),
                 onTap: () {
                    store.connectDevice(device).whenComplete(
                          () => Modular.to
                              .pushNamed('device_details', arguments: device),
                        );
                  },
                  /*onTap: () {
                    store.connect(device).whenComplete(
                          () => Modular.to
                              .pushNamed('device_details', arguments: device),
                        );
                  },*/
                ),
              )
              .toList(),
        );
      },
    );
  }
}