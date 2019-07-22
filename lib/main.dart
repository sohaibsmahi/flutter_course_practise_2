import 'package:flutter/material.dart';
import 'package:todo_list_app/pages/home_page.dart';

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
