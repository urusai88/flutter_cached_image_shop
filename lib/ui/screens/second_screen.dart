import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';

class _AdditionalWidget extends StatefulWidget {
  _AdditionalWidget({
    @required this.imageUrl,
    @required this.title,
    @required this.price,
    this.onUpdate,
  });

  final String imageUrl;
  final String title;
  final int price;
  final void Function(int count) onUpdate;

  @override
  _AdditionalWidgetState createState() => _AdditionalWidgetState();
}

class _AdditionalWidgetState extends State<_AdditionalWidget> {
  int count = 0;

  Future<void> _onRemoveTap() async {
    if (count > 0) {
      setState(() {
        count--;
      });

      widget.onUpdate?.call(count);
    }
  }

  Future<void> _onAddTap() async {
    if (count < 20) {
      setState(() {
        count++;
      });

      widget.onUpdate?.call(count);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget image = AspectRatio(
      aspectRatio: 1,
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
    Widget text = Text(widget.title, maxLines: 3);

    Widget button(IconData icon) {
      return Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          border: Border.fromBorderSide(BorderSide()),
        ),
        child: Icon(icon),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 64,
      child: Row(
        children: [
          image,
          const SizedBox(width: 10),
          Expanded(child: text),
          GestureDetector(
            onTap: _onRemoveTap,
            child: button(Icons.remove),
          ),
          const SizedBox(width: 10),
          Text('$count'),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _onAddTap,
            child: button(Icons.add),
          ),
          const SizedBox(width: 10),
          Text('+${widget.price} р.'),
        ],
      ),
    );
  }
}

class _AdditionalModel {
  final String imageUrl;
  final String title;
  final int price;

  int count;

  _AdditionalModel({
    @required this.imageUrl,
    @required this.title,
    @required this.price,
    this.count = 0,
  });
}

class SecondScreen extends StatefulWidget {
  SecondScreen({@required this.imageUrl, @required this.number});

  final String imageUrl;
  final int number;

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final random = Random();
  final models = <_AdditionalModel>[];

  int count = 0;
  double sum = 0.0;

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < widget.number; ++i) {
      models.add(_AdditionalModel(
        imageUrl: widget.imageUrl,
        title: 'line1\nline2\nline3\nline4',
        price: random.nextInt(94) + 5,
      ));
    }
  }

  void _onUpdate(int c, _AdditionalModel model) {
    model.count = c;

    setState(() {
      count = models.map((e) => e.count).reduce((a, b) => a + b);
      sum = models
          .map((e) => e.count * e.price)
          .reduce((a, b) => a + b)
          .toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: widget.imageUrl,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
    image = AspectRatio(aspectRatio: 4 / 3, child: image);

    Widget text = Text(
      'Произвольный текст как заголовок',
      style: const TextStyle(
        fontSize: 24,
        color: Colors.grey,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.start,
    );

    final children = <Widget>[];

    for (final model in models) {
      children.add(_AdditionalWidget(
        imageUrl: model.imageUrl,
        title: model.title,
        price: model.price,
        onUpdate: (c) => _onUpdate(c, model),
      ));
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          image,
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  text,
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Дополнительно',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 10),
                            ...children,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: DottedDecoration(
              linePosition: LinePosition.top,
              color: Colors.blueGrey,
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Container(
                decoration: DottedDecoration(
                  linePosition: LinePosition.bottom,
                  color: Colors.blueGrey,
                ),
                child: Row(
                  children: [
                    Text(
                      'Дополнительно',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    Text('x$count $sum р.'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
