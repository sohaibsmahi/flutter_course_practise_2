import 'package:flutter/material.dart';
import 'package:flutter_course_practise_2/pages/home_page.dart';

main(List<String> args) => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red, backgroundColor: Colors.grey[100] ),
      home: HomePage(),
    );
  }
}
