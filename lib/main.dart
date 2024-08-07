import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        hintColor: Colors.orange,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String _selectedDay = 'Monday';
  TimeOfDay _selectedTime = TimeOfDay(hour: 0, minute: 0);
  String _selectedActivity = 'Wake up';

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final List<String> _activities = [
    'Wake up',
    'Go to gym',
    'Breakfast',
    'Meetings',
    'Lunch',
    'Quick nap',
    'Go to library',
    'Dinner',
    'Go to sleep',
  ];

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _configureSelectNotificationSubject();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder App'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DropdownButton(
              value: _selectedDay,
              onChanged: (value) {
                setState(() {
                  _selectedDay = value.toString();
                });
              },
              items: _days.map((day) {
                return DropdownMenuItem(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
              style: TextStyle(color: Colors.green),
              icon: Icon(Icons.arrow_downward, color: Colors.green),
              dropdownColor: Colors.grey[200],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text(_selectedTime.format(context)),
              onPressed: () async {
                final TimeOfDay? newTime =
                    await showTimePicker(context: context, initialTime: _selectedTime);
                if (newTime != null) {
                  setState(() {
                    _selectedTime = newTime;
                  });
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            SizedBox(height: 20),
            DropdownButton(
              value: _selectedActivity,
              onChanged: (value) {
                setState(() {
                  _selectedActivity = value.toString();
                });
              },
              items: _activities.map((activity) {
                return DropdownMenuItem(
                  value: activity,
                  child: Text(activity),
                );
              }).toList(),
              style: TextStyle(color: Colors.green),
              icon: Icon(Icons.arrow_downward, color: Colors.green),
              dropdownColor: Colors.grey[200],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Set Reminder'),
              onPressed: () async {
                await _showNotification();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestPermission() async {
    await _flutterLocalNotificationsPlugin.requestPermission();
  }

  void _configureSelectNotificationSubject() {
    _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _showNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('com.example.reminder_app_channel');
    const IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings);

    await _scheduleNotification();
  }

  Future<void> _scheduleNotification() async {
    await _flutterLocalNotificationsPlugin.show(
      0,
      'Notification title',
      'Notification message',
      AndroidNotificationDetails(
        'channelId',
        'channelName',
        channelDescription: 'channelDescription',
      ) as NotificationDetails?,
    );
  }

  Future<void> onSelectNotification(String payload) async {
    // Handle notification tap
  }
}

extension on FlutterLocalNotificationsPlugin {
  requestPermission() {}
}