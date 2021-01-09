import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  SecondScreen({@required this.imageUrl, @required this.number});

  final String imageUrl;
  final int number;

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          image,
        ],
      ),
    );
  }
}
