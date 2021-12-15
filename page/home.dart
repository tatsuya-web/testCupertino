import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Home'),
      ),
      child: ListView(
        children: [
          WebViewCard(),
        ],
      ),
    );
  }
}

class WebViewCard extends StatelessWidget {
  WebViewCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Card(
        elevation: 3,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 25.0),
            child: Expanded(
              child: Center(
                child: Text(
                  'WebView',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute<void>(
                builder: (BuildContext context) {
                  return WebViewPage();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  WebViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text('WebView'),
      ),
      child: SafeArea(
        child: WebView(
          initialUrl: 'https://www.networld-jp.net/',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
