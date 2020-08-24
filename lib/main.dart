// Copyright 2017, Paul DeMarco.
// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
//
//import 'dart:async';
//
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_blue/flutter_blue.dart';
//import 'widgets.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:convert/convert.dart';
//import "package:charcode/ascii.dart";
//import "package:charcode/html_entity.dart";
//import 'package:hex/hex.dart';
//import 'dart:convert';
//
//FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
//void main() {
//  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//  runApp(FlutterBlueApp());
//  print('-----------------------------------------------------');
//  String s = "on0";
//  var encoded = ascii.encode(s);
//  var value  = hex.encode(encoded);
//  print(value);
//  print("-----------------------------------------------------");
//}
//
//
//
//class FlutterBlueApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      color: Colors.lightBlue,
//      home: StreamBuilder<BluetoothState>(
//          stream: FlutterBlue.instance.state,
//          initialData: BluetoothState.unknown,
//          builder: (c, snapshot) {
//            final state = snapshot.data;
//            if (state == BluetoothState.on) {
//              return FindDevicesScreen();
//            }
//            return BluetoothOffScreen(state: state);
//          }),
//    );
//  }
//}
//
//class BluetoothOffScreen extends StatelessWidget {
//  const BluetoothOffScreen({Key key, this.state}) : super(key: key);
//
//  final BluetoothState state;
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Colors.lightBlue,
//      body: Center(
//        child: Column(
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            Icon(
//              Icons.bluetooth_disabled,
//              size: 200.0,
//              color: Colors.white54,
//            ),
//            Text(
//              'Bluetooth Adapter is ${state.toString().substring(15)}.',
//              style: Theme.of(context)
//                  .primaryTextTheme
//                  .subhead
//                  .copyWith(color: Colors.white),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//class FindDevicesScreen extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Hellas Digital Keyless Access'),
//      ),
//      body: RefreshIndicator(
//        onRefresh: () =>
//            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
//        child: SingleChildScrollView(
//          child: Column(
//            children: <Widget>[
//              StreamBuilder<List<BluetoothDevice>>(
//                stream: Stream.periodic(Duration(seconds: 2))
//                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
//                initialData: [],
//                builder: (c, snapshot) => Column(
//                  children: snapshot.data
//                      .map((d) => ListTile(
//                    title: Text(d.name),
//                    subtitle: Text(d.id.toString()),
//                    trailing: StreamBuilder<BluetoothDeviceState>(
//                      stream: d.state,
//                      initialData: BluetoothDeviceState.disconnected,
//                      builder: (c, snapshot) {
//                        if (snapshot.data ==
//                            BluetoothDeviceState.connected) {
//                          return RaisedButton(
//                            child: Text('OPEN'),
//                            onPressed: () => Navigator.of(context).push(
//                                MaterialPageRoute(
//                                    builder: (context) =>
//                                        DeviceScreen(device: d))),
//                          );
//                        }
//                        return Text(snapshot.data.toString());
//                      },
//                    ),
//                  ))
//                      .toList(),
//                ),
//              ),
//              StreamBuilder<List<ScanResult>>(
//                stream: FlutterBlue.instance.scanResults,
//                initialData: [],
//                builder: (c, snapshot) => Column(
//                  children: snapshot.data
//                      .map(
//                        (r) => ScanResultTile(
//                      result: r,
//                      onTap: () => Navigator.of(context)
//                          .push(MaterialPageRoute(builder: (context) {
//                        r.device.connect();
//                        return DeviceScreen(device: r.device);
//                      })),
//                    ),
//                  )
//                      .toList(),
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
//      floatingActionButton: StreamBuilder<bool>(
//        stream: FlutterBlue.instance.isScanning,
//        initialData: false,
//        builder: (c, snapshot) {
//          if (snapshot.data) {
//            return FloatingActionButton(
//              child: Icon(Icons.stop),
//              onPressed: () => FlutterBlue.instance.stopScan(),
//              backgroundColor: Colors.red,
//            );
//          } else {
//            return FloatingActionButton(
//                child: Icon(Icons.search),
//                onPressed: () => FlutterBlue.instance
//                    .startScan(timeout: Duration(seconds: 4)));
//          }
//        },
//      ),
//    );
//  }
//}
//
//class DeviceScreen extends StatefulWidget {
//  const DeviceScreen({Key key, this.device}) : super(key: key);
//
//  final BluetoothDevice device;
//
//  @override
//  _DeviceScreenState createState() => _DeviceScreenState();
//}
//
//class _DeviceScreenState extends State<DeviceScreen> {
//  bool isConnected = false;
//
//  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
//    return services
//        .map(
//          (s) => ServiceTile(
//        service: s,
//        characteristicTiles: s.characteristics
//            .map(
//              (c) => CharacteristicTile(
//            characteristic: c,
//            onReadPressed: () => c.read(),
//            onWritePressed: () {
//              String on0 = "on0";
//              c.write(utf8.encode(on0));
//            } ,
//            onWritePressed1: () {
//              String off0 = "off0";
//              c.write(utf8.encode(off0));
//            },
//            onNotificationPressed: () =>
//                c.setNotifyValue(!c.isNotifying),
//            descriptorTiles: c.descriptors
//                .map(
//                  (d) => DescriptorTile(
//                descriptor: d,
//                onReadPressed: () => d.read(),
//                onWritePressed: () => d.write([11, 12]),
//              ),
//            )
//                .toList(),
//          ),
//        )
//            .toList(),
//      ),
//    )
//        .toList();
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//    new FlutterLocalNotificationsPlugin();
//// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//    var initializationSettingsAndroid =
//    new AndroidInitializationSettings('app_icon');
//    var initializationSettingsIOS = new IOSInitializationSettings(
//        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//    var initializationSettings = new InitializationSettings(
//        initializationSettingsAndroid, initializationSettingsIOS);
//    flutterLocalNotificationsPlugin.initialize(initializationSettings,
//        onSelectNotification: onSelectNotification);
//
//    Timer.periodic(new Duration(seconds: 1), (timer) {
//      FlutterBlue.instance.connectedDevices.then((value) {
//        if (value.length >= 1 && !isConnected) {
//          _showNotificationWithNoBadge("${widget.device.name}", "Connected");
//          isConnected = true;
//        } else if (value.length == 0 && isConnected) {
//          _showNotificationWithNoBadge("${widget.device.name}", "Disconnected");
//          isConnected = false;
//        }
//      });
//    });
//  }
//
//  Future<void> _showNotificationWithNoBadge(String title, String body) async {
//    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//        'no badge channel', 'no badge name', 'no badge description',
//        channelShowBadge: false,
//        importance: Importance.Max,
//        priority: Priority.High,
//        onlyAlertOnce: true);
//    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//    var platformChannelSpecifics = NotificationDetails(
//        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//    await flutterLocalNotificationsPlugin
//        .show(0, title, body, platformChannelSpecifics, payload: 'item x');
//  }
//
//  Future<void> onDidReceiveLocalNotification(
//      int id, String title, String body, String payload) async {
//    // display a dialog with the notification details, tap ok to go to another page
//    await showDialog(
//      context: context,
//      builder: (BuildContext context) => CupertinoAlertDialog(
//        title: Text(title),
//        content: Text(body),
//        actions: [
//          CupertinoDialogAction(
//            isDefaultAction: true,
//            child: Text('Ok'),
//            onPressed: () async {
//              Navigator.of(context, rootNavigator: true).pop();
//            },
//          )
//        ],
//      ),
//    );
//  }
//
//  Future<void> onSelectNotification(String payload) async {
//    if (payload != null) {
//      debugPrint('notification payload: ' + payload);
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.device.name),
//        actions: <Widget>[
//          StreamBuilder<BluetoothDeviceState>(
//            stream: widget.device.state,
//            initialData: BluetoothDeviceState.connecting,
//            builder: (c, snapshot) {
//              VoidCallback onPressed;
//              String text;
//              switch (snapshot.data) {
//                case BluetoothDeviceState.connected:
//                  onPressed = () => widget.device.disconnect();
//                  text = 'DISCONNECT';
//                  break;
//                case BluetoothDeviceState.disconnected:
//                  onPressed = () => widget.device.connect();
//                  text = 'CONNECT';
//                  break;
//                default:
//                  onPressed = null;
//                  text = snapshot.data.toString().substring(21).toUpperCase();
//                  break;
//              }
//              return FlatButton(
//                  onPressed: onPressed,
//                  child: Text(
//                    text,
//                    style: Theme.of(context)
//                        .primaryTextTheme
//                        .button
//                        .copyWith(color: Colors.white),
//                  ));
//            },
//          )
//        ],
//      ),
//      body: SingleChildScrollView(
//        child: Column(
//          children: <Widget>[
//            StreamBuilder<BluetoothDeviceState>(
//              stream: widget.device.state,
//              initialData: BluetoothDeviceState.connecting,
//              builder: (c, snapshot) => ListTile(
//                leading: (snapshot.data == BluetoothDeviceState.connected)
//                    ? Icon(Icons.bluetooth_connected)
//                    : Icon(Icons.bluetooth_disabled),
//                title: Text(
//                    'Device is ${snapshot.data.toString().split('.')[1]}.'),
//                subtitle: Text('${widget.device.id}'),
//                trailing: StreamBuilder<bool>(
//                  stream: widget.device.isDiscoveringServices,
//                  initialData: false,
//                  builder: (c, snapshot) => IndexedStack(
//                    index: snapshot.data ? 1 : 0,
//                    children: <Widget>[
//                      IconButton(
//                        icon: Icon(Icons.refresh),
//                        onPressed: () => widget.device.discoverServices(),
//                      ),
//                      IconButton(
//                        icon: SizedBox(
//                          child: CircularProgressIndicator(
//                            valueColor: AlwaysStoppedAnimation(Colors.grey),
//                          ),
//                          width: 18.0,
//                          height: 18.0,
//                        ),
//                        onPressed: null,
//                      )
//                    ],
//                  ),
//                ),
//              ),
//            ),
//            StreamBuilder<List<BluetoothService>>(
//              stream: widget.device.services,
//              initialData: [],
//              builder: (c, snapshot) {
//                return Column(
//                  children: _buildServiceTiles(snapshot.data),
//                );
//              },
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}



//
import 'package:flutter/material.dart';
import 'dart:async';
import 'LoginPage.dart';
import 'widgets.dart';
import 'sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:convert/convert.dart';
import 'dart:convert';
import 'package:flutter_picker/flutter_picker.dart';
import 'PickerData.dart';
import 'pickervalue.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
String s = "on0";

void main() {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  runApp(FlutterBlueApp());
  print('-----------------------------------------------------');

  var encoded = ascii.encode(s);
  var value  = hex.encode(encoded);
  print(value);
  print("-----------------------------------------------------");
}



class FlutterBlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      title: 'Named Routes Demo',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/second',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => LoginPage(), //ShowDataPage()
        '/second': (context) => StreamBuilder<BluetoothState>(
            stream: FlutterBlue.instance.state,
            initialData: BluetoothState.unknown,
            builder: (c, snapshot) {
              final state = snapshot.data;
              if (state == BluetoothState.on) {
                return FindDevicesScreen();
              }
              return BluetoothOffScreen(state: state);
            }),
      },

    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state.toString().substring(15)}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatefulWidget {
  @override
  _FindDevicesScreenState createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  final double listSpec = 4.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String stateText;
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text('Hellas Digital Keyless Access'),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: new Center(
                  child: new Text(
                    "Settings",
                    style: new TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 15.0),
                  )),
              decoration: new BoxDecoration(color: Colors.lightBlue),
            ),
            Card(
              child: ListTile(
                title: new Center(
                    child: new Text(
                      "picker",
                      style: new TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.0),
                    )),
                onTap: () {
                  showPicker(context);
                },
              ),
            ),
            Card(
              child: ListTile(
                title: new Center(
                    child: new Text(
                      "Place Holder",
                      style: new TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.0),
                    )),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ),
            Card(
              child: ListTile(
                title: new Center(
                    child: new Text(
                      "Place Holder",
                      style: new TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.0),
                    )),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ),
            Card(
              child: ListTile(
                title: new Center(
                    child: new Text(
                      "Place Holder",
                      style: new TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.0),
                    )),
                onTap: () {
                  Navigator.pushNamed(
                      context, '/addDevice'); // Update the state of the app.
                  // ...
                },
              ),
            ),
            Card(
              child: ListTile(
                title: new Center(
                    child: new Text(
                      "Place Holder",
                      style: new TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.0),
                    )),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ),
            Card(
              child: ListTile(
                title: new Center(
                    child: new Text(
                      "Sign Out",
                      style: new TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.0),
                    )),
                onTap: () {
                  signOutGoogle();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                        return LoginPage();
                      }),
                      ModalRoute.withName(
                          '/')); // Update the state of the app.
                  // ...
                },
              ),
            ),
          ],
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map((d) => ListTile(
                    title: Text(d.name),
                    subtitle: Text(d.id.toString()),
                    trailing: StreamBuilder<BluetoothDeviceState>(
                      stream: d.state,
                      initialData: BluetoothDeviceState.disconnected,
                      builder: (c, snapshot) {
                        if (snapshot.data ==
                            BluetoothDeviceState.connected) {
                          return RaisedButton(
                            child: Text('OPEN'),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DeviceScreen(device: d)));},
                          );
                        }
                        return Text(snapshot.data.toString());
                      },
                    ),
                  ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map(
                        (r) => ScanResultTile(
                      result: r,
                      onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        r.device.connect();
                        return DeviceScreen(device: r.device);
                      })),
                    ),
                  )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return GestureDetector(

              onLongPress: (){
                setState(() {
                  _visible = !_visible;
                });
                showPicker(context);
                },
              child: Container(

                child: Visibility(
                  visible: _visible,
                  child: FloatingActionButton(
                      child: Icon(Icons.search),
                      onPressed: () => FlutterBlue.instance
                          .startScan(timeout: Duration(seconds: 4))),
                ),
              ),
            );
          }
        },
      ),
    );
  }
  showPicker(BuildContext context) {

    Picker picker = Picker(
        adapter: PickerDataAdapter<String>(pickerdata: JsonDecoder().convert(PickerData)),
        changeToFirst: false,
        textAlign: TextAlign.left,
        textStyle: const TextStyle(color: Colors.blue),
        selectedTextStyle: TextStyle(color: Colors.red),
        columnPadding: const EdgeInsets.all(0.0),
        onConfirm: (Picker picker, List value) {
          print(value[0].toString());
          if(value[0]==0){
            //seconds
            pickervalue.s = 'on'+(value[1]).toString();
            print((value[1]+1).toString());
            print(pickervalue.s);
            print(picker.getSelectedValues());
          }
          else{
            //minutes
            print('minutes');
            print(((value[1]+1)*60).toString());
            pickervalue.s = 'on'+((value[1]+1)*60).toString();
            print(((value[1]+1)*60).toString());
            print(pickervalue.s);
            print(picker.getSelectedValues());
          }
          setState(() {
            _visible = !_visible;
          });
        }
    );
    picker.show(_scaffoldKey.currentState);
  }
}


class DeviceScreen extends StatefulWidget {
  const DeviceScreen({Key key, this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  bool isConnected = false;
  String message  = pickervalue.s;

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (s) => ServiceTile(
        service: s,
        characteristicTiles: s.characteristics
            .map(
              (c) => CharacteristicTile(
            characteristic: c,
            onReadPressed: () => c.read(),
            onWritePressed: () {
              setState(() {
                message = pickervalue.s;
              });
              print('aaaa');
              print(pickervalue.s);
              print('aaaa');
              c.write(utf8.encode(pickervalue.s));
            } ,
            onWritePressed1: () {
              String off0 = "off0";
              c.write(utf8.encode(off0));
            },
            onNotificationPressed: () =>
                c.setNotifyValue(!c.isNotifying),
            descriptorTiles: c.descriptors
                .map(
                  (d) => DescriptorTile(
                descriptor: d,
                onReadPressed: () => d.read(),
                onWritePressed: () => d.write([11, 12]),
              ),
            )
                .toList(),
          ),
        )
            .toList(),
      ),
    )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    Timer.periodic(new Duration(seconds: 1), (timer) {
      FlutterBlue.instance.connectedDevices.then((value) {

        if (value.length >= 1 && !isConnected) {
          widget.device.discoverServices();
          _showNotificationWithNoBadge("${widget.device.name}", "Connected");
          isConnected = true;
        } else if (value.length == 0 && isConnected) {
          _showNotificationWithNoBadge("${widget.device.name}", "Disconnected");
          isConnected = false;
        }
      });
    });
  }

  Future<void> _showNotificationWithNoBadge(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'no badge channel', 'no badge name', 'no badge description',
        channelShowBadge: false,
        importance: Importance.Max,
        priority: Priority.High,
        onlyAlertOnce: true);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'item x');
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: widget.device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => widget.device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => widget.device.connect();
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return FlatButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        .copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: widget.device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading: (snapshot.data == BluetoothDeviceState.connected)
                    ? Icon(Icons.bluetooth_connected)
                    : Icon(Icons.bluetooth_disabled),
                title: Text(
                    'Device is ${snapshot.data.toString().split('.')[1]}.'),
                subtitle: Text('${widget.device.id}'),
                trailing: StreamBuilder<bool>(
                  stream: widget.device.isDiscoveringServices,
                  initialData: false,
                  builder: (c, snapshot) => IndexedStack(
                    index: snapshot.data ? 1 : 0,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.sync),
                        onPressed: () => widget.device.discoverServices(),
                      ),
                      IconButton(
                        icon: SizedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: widget.device.services,
              initialData: [],
              builder: (c, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

