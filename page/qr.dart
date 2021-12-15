import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class QRPage extends StatelessWidget {
  QRPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('QR'),
      ),
      child: Center(
        child: CupertinoButton(
          child: const Text('QRPage'),
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
