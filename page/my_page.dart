import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:testcupertino/page/auth.dart';

import '../provider.dart';

class MyPage extends ConsumerWidget {
  MyPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider.state).state;
    final AsyncValue<QuerySnapshot> asyncPointQuery = ref.watch(pointProvider);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('MyPage'),
        trailing: GestureDetector(
          child: const Icon(CupertinoIcons.arrow_right_circle),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (BuildContext context) {
                  return InitPage();
                },
              ),
            );
          },
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            QrImage(
              data: user!.uid,
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 15.0),
            Text(user.uid),
            const SizedBox(height: 15.0),
            asyncPointQuery.when(
              data: (QuerySnapshot query) {
                final Object point = query.docs.map((document) {
                  return document['point'];
                });
                return Text(
                  '現在のポイント : $point',
                  style: const TextStyle(fontSize: 17),
                );
              },
              loading: () {
                return const Text('読込中...');
              },
              error: (e, stackTrace) {
                return Text(e.toString());
              },
            ),
          ],
        ),
      ),
    );
  }
}
