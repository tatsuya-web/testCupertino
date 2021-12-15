import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import './my_page.dart';
import '../provider.dart';

class InitPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                child: const Text('ログインまたは会員登録をしてください。'),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                child: CupertinoButton(
                  color: Colors.blue,
                  child: const Text('ログイン'),
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute<void>(
                        builder: (BuildContext context) {
                          return const LogInPage();
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                child: CupertinoButton(
                  color: Colors.blue,
                  child: const Text('会員登録'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogInPage extends ConsumerWidget {
  const LogInPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoText = ref.watch(infoTextProvider.state).state;
    final email = ref.watch(emailProvider.state).state;
    final password = ref.watch(passwordProvider.state).state;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('ログイン'),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CupertinoTextField(
                placeholder: 'メールアドレス',
                showCursor: true,
                onChanged: (String value) {
                  ref.read(emailProvider.state).state = value;
                },
              ),
              const SizedBox(height: 20),
              CupertinoTextField(
                placeholder: 'パスワード',
                showCursor: true,
                obscureText: true,
                onChanged: (String value) {
                  ref.read(passwordProvider.state).state = value;
                },
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(infoText),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                child: CupertinoButton(
                  color: Colors.blue,
                  child: const Text('ログイン'),
                  onPressed: () async {
                    try {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final result = await auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      ref.read(userProvider.state).state = result.user;

                      final userEmail = result.user!.email;
                      final loginDate =
                          DateTime.now().toLocal().toIso8601String();
                      await FirebaseFirestore.instance
                          .collection('v0')
                          .doc('stanp')
                          .collection('users')
                          .doc(userEmail)
                          .update({'loginDate': loginDate});

                      await Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (context) {
                            return AppPage();
                          },
                          fullscreenDialog: true,
                        ),
                      );
                    } catch (e) {
                      ref.read(infoTextProvider.state).state =
                          "ログインに失敗しました:${e.toString()}";
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends ConsumerWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoText = ref.watch(infoTextProvider.state).state;
    final email = ref.watch(emailProvider.state).state;
    final password = ref.watch(passwordProvider.state).state;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('会員登録'),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CupertinoTextField(
                placeholder: 'メールアドレス',
                showCursor: true,
                onChanged: (String value) {
                  ref.read(emailProvider.state).state = value;
                },
              ),
              const SizedBox(height: 20),
              CupertinoTextField(
                placeholder: 'パスワード',
                showCursor: true,
                obscureText: true,
                onChanged: (String value) {
                  ref.read(passwordProvider.state).state = value;
                },
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(infoText),
              ),
              Container(
                width: double.infinity,
                child: CupertinoButton(
                  color: Colors.blue,
                  child: const Text('ユーザー登録'),
                  onPressed: () async {
                    try {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final result = await auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                      ref.read(userProvider.state).state = result.user;

                      final date = DateTime.now().toLocal().toIso8601String();
                      final userId = result.user?.uid;
                      final userEmail = result.user?.email;
                      await FirebaseFirestore.instance
                          .collection('v0')
                          .doc('stanp')
                          .collection('users')
                          .doc(userEmail)
                          .set({
                        'createDate': date,
                        'updateDate': null,
                        'loginDate': date,
                        'stanpDate': null,
                        'email': userEmail,
                        'point': 0,
                        'uid': userId,
                      });

                      await Navigator.of(context)
                          .pushReplacement(CupertinoPageRoute(
                        builder: (context) {
                          return AppPage();
                        },
                        fullscreenDialog: true,
                      ));
                    } catch (e) {
                      ref.read(infoTextProvider.state).state =
                          "登録に失敗しました:${e.toString()}";
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
