import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/search_page.dart';

void main() {
  runApp(AppWidget(title: "Open Weather"));
}

class AppWidget extends StatelessWidget {
  final String title;

  const AppWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      routes: {'/search_page': (context) => const SearchPage()},
    );
  }
}
