import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyFirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Initialize Firebase Messaging
  static Future<void> init() async {
    print("🔧 Initializing Firebase Messaging...");

    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("✅ Notification Permission Granted");
    } else {
      print("❌ Notification Permission Denied");
    }

    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    print("🔥 BADHYATA FCM Token: $token");

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground Notification Received:");
      print("   → Title: ${message.notification?.title}");
      print("   → Body: ${message.notification?.body}");
      print("   → Data: ${message.data}");

      _showNotification(message);
    });

    // When app is in background & user taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🚀 Notification Clicked (Background)");
      print("   → Title: ${message.notification?.title}");
      print("   → Data: ${message.data}");
    });

    // Initialize local notifications
    _initLocalNotifications();

    print("✅ Firebase Messaging Initialized Successfully");
  }

  /// Initialize Local Notifications (Android)
  static void _initLocalNotifications() {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("🖱 Notification tapped by user");
        print("   → Payload: ${response.payload}");
      },
    );

    print("🔔 Local Notification Channel Initialized");
  }

  /// Show local notification when app is in foreground
  static Future<void> _showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    if (notification == null) {
      print("⚠️ No notification content to display");
      return;
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel_id',
          'Default Channel',
          channelDescription: 'This channel is used for all notifications',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    try {
      await _flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique ID
        notification.title ?? 'Notification',
        notification.body ?? '',
        details,
      );

      print("🔔 Local Notification Shown:");
      print("   → Title: ${notification.title}");
      print("   → Body: ${notification.body}");
    } catch (e) {
      print("⚠️ Error showing notification: $e");
    }
  }
}

/// 🔥 Background notification handler (must be top-level)
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("🌙 Background Notification Received:");
  print("   → Title: ${message.notification?.title}");
  print("   → Body: ${message.notification?.body}");
  print("   → Data: ${message.data}");
}
