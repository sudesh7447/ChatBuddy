// ignore_for_file: prefer_const_constructors

import 'package:chat_buddy/api/preferences.dart';
import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/providers/follower_provider.dart';
import 'package:chat_buddy/providers/following_provider.dart';
import 'package:chat_buddy/providers/theme_provider.dart';
import 'package:chat_buddy/providers/user_model_provider.dart';
import 'package:chat_buddy/screens/auth_screen/profile_setup_screen.dart';
import 'package:chat_buddy/screens/splash_screen.dart';
import 'package:chat_buddy/screens/auth_screen/verify_user_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

User? user = FirebaseAuth.instance.currentUser;

bool isAuthenticated = false;
bool _theme = false;

Future<void> _messageHandler(RemoteMessage message) async {
  // print('background message ${message.notification!.body}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // print("Handling a background message: ${message.messageId}");
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ThemePreferences.init();
  await dotenv.load(fileName: ".env");

  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');

  // Suyog
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  //Local Notification
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
          ));
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // print('A new onMessageOpenedApp event was published!');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      // showDialog(
      //     context: context,
      //     builder: (_) {
      //       return AlertDialog(
      //         title: Text(notification.title),
      //         content: SingleChildScrollView(
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [Text(notification.body)],
      //           ),
      //         ),
      //       );
      //     });
      // print("Body : " + notification.body!);
    }
  });

  _theme = ThemePreferences.getTheme() ?? false;

  print('_theme');
  print(_theme);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserModelProvider()),
        ChangeNotifierProvider(create: (_) => FollowingProvider()),
        ChangeNotifierProvider(create: (_) => FollowerProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider(_theme)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void showNotification(String title, String message) {
    flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          color: Colors.blue,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // showNotification("Hey", "Welcome");

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      // print(event.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // print('Message clicked!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: kGreenShadeColor),
      title: 'ChatBuddy',
      home: user == null ? SplashScreen() : VerifyUserScreen(),
    );
  }
}
