import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import './page/coupon.dart';
import './page/topics.dart';
import 'page/my_page.dart';

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
