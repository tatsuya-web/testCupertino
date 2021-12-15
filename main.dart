import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import './page/home.dart';
import './page/coupon.dart';
import './page/qr.dart';
import './page/topics.dart';
import './page/profile.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: const CupertinoThemeData(primaryColor: Colors.lightBlue),
      home: AppPage(),
    );
  }
}

class AppPage extends StatelessWidget {
  AppPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_sharp),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'クーポン',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_sharp),
            label: 'QRコード',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_sharp),
            label: 'お知らせ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'プロフィール',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            switch (index) {
              case 0:
                return HomePage();
              case 1:
                return CouponPage();
              case 2:
                return QRPage();
              case 3:
                return TopicsPage();
              case 4:
                return ProfilePage();
              default:
                return HomePage();
            }
          },
        );
      },
    );
  }
}
