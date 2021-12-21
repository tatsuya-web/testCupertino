import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './page/coupon.dart';
import './page/topics.dart';
import './page/my_page.dart';
import './page/auth.dart';
import './provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("バックグラウンドでメッセージを受け取りました");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //バックグラウンド用
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: const CupertinoThemeData(primaryColor: Colors.brown),
        home: AppPage());
  }
}

class AppPage extends ConsumerWidget {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseInAppMessaging _firebaseInAppMessaging =
      FirebaseInAppMessaging.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _firebaseMessaging.requestPermission();
    _firebaseInAppMessaging.triggerEvent('update_event');
    _firebaseMessaging.getToken().then((String? token) {
      ref.watch(fcmTokenProvider.state).state = token.toString();
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("フォアグラウンドでメッセージを受け取りました");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        // フォアグラウンドで通知を受け取った場合、通知を作成して表示する
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            // 通知channelを設定する
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });

    if (FirebaseAuth.instance.currentUser == null) {
      return InitPage();
    } else {
      return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          currentIndex: 2,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number),
              label: 'クーポン',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.topic_sharp),
              label: 'トピック',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_sharp),
              label: 'マイページ',
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              switch (index) {
                case 0:
                  return CouponPage();
                case 1:
                  return TopicsPage();
                case 2:
                  return MyPage();
                default:
                  return MyPage();
              }
            },
          );
        },
      );
    }
  }
}
