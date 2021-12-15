import 'dart:async'; //非同期処理用
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

final topicsProvider = ChangeNotifierProvider<ArticleModel>(
  (ref) => ArticleModel()..getWpArticle(),
);

class WPArticle {
  WPArticle(
    this.title,
    this.date,
    this.link,
  );

  //タイトル
  String title;
  //投稿日付
  String date;
  //リンク
  String link;
}

class ArticleModel extends ChangeNotifier {
  //記事リスト
  List<WPArticle> articleList = <WPArticle>[];
  //ローディング
  bool isLoading = true;

  //WP APIからデータを取得
  Future<void> getWpArticle() async {
    //読み込みたいWordPressサイトのエンドポイント
    Uri url = Uri.parse(
        'https://www.networld-jp.net/wp-json/wp/v2/works?per_page=100');
    final http.Response response =
        await http.get(url, headers: {'Accept': 'application.json'});

    //もし成功したら
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> responseContent =
          jsonDecode(response.body).cast<Map<String, dynamic>>()
              as List<Map<String, dynamic>>;
      final List<WPArticle> topicsList = responseContent
          .map(
            (Map<String, dynamic> wpArticle) => WPArticle(
              wpArticle['title']['rendered'] as String,
              changeDateFormat(wpArticle['date'] as String),
              wpArticle['link'] as String,
            ),
          )
          .toList();
      this.articleList = topicsList;
      this.isLoading = false;
      notifyListeners();
    } else {
      this.isLoading = false;
      notifyListeners();
      throw Exception('response is failed');
    }
  }

  //HTMLタグ排除
  String removeHtmlTag(String htmlText) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  //年月表示
  String changeDateFormat(String date) {
    initializeDateFormatting('ja_JP');
    // StringからDate
    final DateTime datetime = DateTime.parse(date);

    final DateFormat formatter = DateFormat('yyyy年MM月dd日', 'ja_JP');
    // DateからString
    final String formatted = formatter.format(datetime);
    return formatted;
  }
}

class TopicsPage extends StatelessWidget {
  TopicsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Info'),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15.0,
        ),
        child: TopicsCardList(),
      ),
    );
  }
}

class TopicsCardList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicsModel = ref.watch(topicsProvider);
    return Stack(
      children: [
        Consumer(
          builder: (context, ref, child) {
            final List<Widget> articleList = topicsModel.articleList
                .map(
                  (WPArticle wpArticle) => TopicsCard(
                      title: wpArticle.title,
                      date: wpArticle.date,
                      link: wpArticle.link),
                )
                .toList();
            return ListView(
              children: articleList,
            );
          },
        ),
        Consumer(builder: (context, ref, child) {
          return loadingScreen(topicsModel.isLoading);
        }),
      ],
    );
  }

  Widget loadingScreen(bool isLoading) {
    if (isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    } else {
      return Container();
    }
  }
}

class TopicsCard extends StatelessWidget {
  final String title;
  final String date;
  final String link;
  const TopicsCard(
      {Key? key, required this.title, required this.date, required this.link})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 3,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          child: Expanded(
            child: ListTile(
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                date,
                style: const TextStyle(
                    fontSize: 13.0, fontWeight: FontWeight.w300),
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute<void>(
                builder: (BuildContext context) {
                  return TopicsWebView(
                    link: link,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class TopicsWebView extends StatelessWidget {
  final String link;
  const TopicsWebView({Key? key, required this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('お知らせ'),
      ),
      child: SafeArea(
        child: WebView(
          initialUrl: link,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
