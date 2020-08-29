import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Simple Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: DynamicText());
  }
}

class DynamicText extends StatefulWidget {
  final url = 'https://medium-json-dynamic-widget.herokuapp.com/mainpage';

  @override
  _DynamicTextState createState() => _DynamicTextState();
}

class _DynamicTextState extends State<DynamicText> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<http.Response> snapshot) {
        if (snapshot.hasData) {
          var widgetJson = json.decode(snapshot.data.body);
          var widget = JsonWidgetData.fromDynamic(
            widgetJson,
          );
          return widget.build(context: context);
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      future: _getWidget(),
    );
  }

  Future<http.Response> _getWidget() async {
    return http.get(widget.url);
  }
}

class SimpleText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Static Widget'),
      ),
      body: Center(
        child: Text('This is a very important message!'),
      ),
    );
  }
}
