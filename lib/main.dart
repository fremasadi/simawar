import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simawar/app/constants/const_color.dart';
import 'app/routes/app_pages.dart';

// Define FlutterLocalNotificationsPlugin as a global variable
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Define the notification channel for Android
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'your_channel_id',
  'your_channel_name',
  description: 'your_channel_description',
  importance: Importance.max,
);

// Background handler needs to be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase for background notifications
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBgCMcqSxsiSaTSOe8iQQMmDBpdfTjXqNY',
      appId: '1:896431639068:android:7463b986307c9ec9426dd9',
      projectId: 'simawar-8ac1b',
      messagingSenderId: '896431639068',
      storageBucket: '',
    ),
  );

  // Don't show notification here, as background notifications are handled automatically
}

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase first
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBgCMcqSxsiSaTSOe8iQQMmDBpdfTjXqNY',
      appId: '1:896431639068:android:7463b986307c9ec9426dd9',
      projectId: 'simawar-8ac1b',
      messagingSenderId: '896431639068',
      storageBucket: '',
    ),
  );

  // Set up Firebase messaging background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize local notifications
  await _initializeLocalNotifications();

  // Request permissions
  await requestNotificationPermission();
  await requestAndroidNotificationPermission();

  // Set up foreground messaging handler
  setupFirebaseMessaging();

  runApp(const MyApp());
}

Future<void> requestNotificationPermission() async {
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  } else {}
}

Future<void> requestAndroidNotificationPermission() async {
  PermissionStatus status = await Permission.notification.request();

  if (status.isGranted) {
  } else if (status.isDenied) {
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
  }
}

Future<void> _initializeLocalNotifications() async {
  // Initialize Android settings
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // Initialize platform settings for iOS and Android
  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );

  // Initialize the plugin with action callback
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification taps here
    },
  );

  // Create the Android notification channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Get FCM token for this device
  String? token = await FirebaseMessaging.instance.getToken();
}

void setupFirebaseMessaging() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // If notification is not null, show it
    if (message.notification != null) {
      showNotification(message);
    }
  });

  // Handle notification taps when app is in background but not terminated
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // Handle navigation or other actions here
  });
}

void showNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: message.data.toString(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          builder: (context, child) {
            final MediaQueryData data = MediaQuery.of(context);
            return MediaQuery(
                data: data.copyWith(
                  textScaler: const TextScaler.linear(1.10),
                ),
                child: child!);
          },
          theme: ThemeData(
            scaffoldBackgroundColor: ConstColor.backgroundColor,
            fontFamily: 'Poppins',
          ),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
