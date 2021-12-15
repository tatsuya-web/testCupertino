import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CouponPage extends StatelessWidget {
  CouponPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Coupon'),
      ),
      child: ListView(
        children: [
          CouponCard(),
          CouponCard(),
          CouponCard(),
          CouponCard(),
          CouponCard(),
        ],
      ),
    );
  }
}

class CouponCard extends StatelessWidget {
  CouponCard({Key? key}) : super(key: key);
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
          child: Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.47,
                  minWidth: MediaQuery.of(context).size.width * 0.47,
                  maxHeight: 200.0,
                ),
                child: const ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                  ),
                  child: Image(
                    image: AssetImage('assets/images/sample/img-coffee.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Expanded(
                child: ListTile(
                  title: Text(
                    'コーヒー豆',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '2022-00-00',
                    style:
                        TextStyle(fontSize: 13.0, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute<void>(
                builder: (BuildContext context) {
                  return CouponContentsPage();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class CouponContentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('コーヒー豆'),
      ),
      child: ListView(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width * 1,
              minHeight: MediaQuery.of(context).size.height * 0.45,
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/sample/img-coffee.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 25.0,
          ),
          Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                width: double.infinity,
                child: const Text(
                  'コーヒー豆',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                width: double.infinity,
                child: Row(
                  children: const [
                    Text(
                      'クーポンコード',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      '#202',
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 4.0,
                ),
                width: double.infinity,
                child: const Text(
                  'ここにコーヒー豆のクーポンの説明が入ります。ここにコーヒー豆のクーポンの説明が入ります。ここにコーヒー豆のクーポンの説明が入ります。ここにコーヒー豆のクーポンの説明が入ります。ここにコーヒー豆のクーポンの説明が入ります。ここにコーヒー豆のクーポンの説明が入ります。ここにコーヒー豆のクーポンの説明が入ります。ここにコーヒー豆のクーポンの説明が入ります。',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              const Center(
                child: CupertinoButton(
                  child: Text(
                    'クーポンを利用する',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue),
                  ),
                  onPressed: null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
