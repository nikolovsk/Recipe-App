import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:recipe_app/screens/home_screen.dart';
import 'package:recipe_app/screens/random_meal_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> setupFlutterNotifications() async {
  const AndroidInitializationSettings androidSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
  InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'recipe_channel',
    'Recipe Notifications',
    description: 'Channel for recipe notifications',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

Future<void> scheduleDailyNotification() async {
  final now = tz.TZDateTime.now(tz.local);

  final scheduledDate = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    15,
    15,
  );

  print("Schedule button clicked!");

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Recipe of the Day',
    'Check out your new recipe!',
    scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(seconds: 5))
        : scheduledDate,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'recipe_channel',
        'Recipe Notifications',
        channelDescription: 'Daily recipe reminders',
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.inexact,
    matchDateTimeComponents: DateTimeComponents.time,
  );

  print("Daily notification scheduled at ${scheduledDate.hour}:${scheduledDate.minute}");
}

Future<void> scheduleReminderNotification() async {
  print("Scheduling reminder notification...");

  await flutterLocalNotificationsPlugin.show(
    1,
    'Test Recipe',
    'This is a test notification',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'recipe_channel',
        'Recipe Notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
  );
  print("Notification scheduled!");
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  tz.initializeTimeZones();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await setupFlutterNotifications();

  NotificationSettings settings =
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print("Permission status: ${settings.authorizationStatus}");

  String? token = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $token");

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("FCM (foreground): ${message.notification?.title}");

    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'recipe_channel',
          'Recipe Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print("User tapped notification");
  });

  await scheduleDailyNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meals App',
        initialRoute: "/",
        routes: {
          "/": (context) => const HomeScreen(),
          "/random": (context) => const RandomMealScreen(),
        }
    );
  }
}
