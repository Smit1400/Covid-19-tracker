import 'package:covid_19_tracker/app/summary_of_all_countrie.dart';
import 'package:covid_19_tracker/wrapper.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
    );
  }
}
