// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // tz.setLocalLocation(tz.getLocation('JST'));
  tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter FCM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter FCM First Sample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future onSelectNotification(String payload) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Notification'),
        content: Text('$payload'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Your token'),
            Divider(),
            Text('Message'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showNotification,
        label: Text('Call Function'),
        icon: Icon(Icons.cloud),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }

  showNotification() async {
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(iOS: iOS);
    final now = DateTime.now();
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.getLocation('Asia/Tokyo'),
            now.year, now.month, now.day, now.hour, now.minute, now.second)
        .add(Duration(seconds: 5));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'New Tutorial',
      'Local Notification',
      scheduledDate,
      NotificationDetails(
          android: AndroidNotificationDetails('your channel id',
              'your channel name', 'your channel description')),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
