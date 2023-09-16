import 'package:adopt_v2/src/core/widgets/message_dialog.dart';
import 'package:adopt_v2/src/features/reminders/models/Reminder.dart';
import 'package:adopt_v2/src/features/reminders/repositories/reminder_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;


class ReminderListScreen extends StatefulWidget {
  @override
  _ReminderListScreenState createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  List<Reminder> reminderList = [];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  @override
  void initState() {
    super.initState();
    // tz.initializeTimeZones(); // Initialize time zones
    initializeNotifications();
    fetchReminders();
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: selectNotification,
    );
  }

  Future<void> selectNotification(NotificationResponse notificationResponse) async {
    // Handle notification click event here
  }

  Future<void> fetchReminders() async {
    try {
      List<Reminder> fetchedData;
      fetchedData = await ReminderRepository().fetchAllReminders();
      setState(() {
        reminderList = fetchedData;
        // scheduleNotifications(); // Schedule the notifications for fetched reminders
        for (Reminder reminder in reminderList) {
          scheduleNotification(reminder.date, reminder.time, reminder.title, reminder.description);
        }
      });
    } catch (e) {
      print("*******************************");
      print(e);
      print("*******************************");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MessageDialog(
            title: 'Error',
            content: 'Failed to fetch Reminders: $e',
            icon: Icons.error, // Optional: You can provide an error icon
            iconColor: Colors.red, // Optional: Set the icon color
            buttonColor: Colors.red, // Optional: Set the button text color
            buttonText: 'OK',
            onButtonPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          );
        },
      );
    }
  }

  void scheduleNotifications() {
    // Clear any previously scheduled notifications
    flutterLocalNotificationsPlugin.cancelAll();

    for (Reminder reminder in reminderList) {
      DateTime dateTime = DateTime(
        reminder.date.year,
        reminder.date.month,
        reminder.date.day,
        reminder.time.hour,
        reminder.time.minute,
      );

      tz.TZDateTime scheduledDate = tz.TZDateTime.from(
        tz.local as DateTime,
        dateTime as tz.Location,
      );

      flutterLocalNotificationsPlugin.zonedSchedule(
        reminder.Reminderid, // Use the reminder's ID as the notification ID
        reminder.title,
        reminder.description,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel_id',
            'channel_name',
            // 'channel_description',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> scheduleNotification(DateTime date, TimeOfDay time, String title, String description) async {
    final now = DateTime.now();
    final notificationDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    final scheduledDate = notificationDate.isAfter(now) ? notificationDate : now.add(const Duration(seconds: 1));

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id', 'your_channel_name',
      // 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    // var platformChannelSpecifics = NotificationDetails(
    //   android: androidPlatformChannelSpecifics,
    //   iOS: iOSPlatformChannelSpecifics,
    // );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      description,
      tz.TZDateTime.from(scheduledDate, tz.local),
      androidPlatformChannelSpecifics as NotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder List'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: GridView.count(
                crossAxisCount: 1,
                padding: const EdgeInsets.all(16.0),
                children: reminderList
                    .map(
                      (reminder) => GestureDetector(
                    onTap: () {
                      _showReminderDialog(reminder);
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8.0),
                            Text(
                              reminder.title,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              reminder.description,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Created: ${reminder.date}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReminderDialog(Reminder reminder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(reminder.title),
          content: Text(reminder.description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
