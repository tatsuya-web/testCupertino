import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MyPage extends StatelessWidget {
  MyPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('MyPage'),
      ),
      child: Center(
        child: CupertinoButton(
          child: const Text('ProfielPage'),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute<void>(
                builder: (BuildContext context) {
                  return _NextPage();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('_Next'),
      ),
      child: Center(
        child: CupertinoButton(
          child: const Text('_NextPage'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
