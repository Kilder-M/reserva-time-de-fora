import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'main_page.dart';

class AppWidget extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/':  (context) => MyApp()
      },
      initialRoute: '/',
      theme: ThemeData(
        canvasColor: Colors.grey[850],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        accentColor: Colors.pinkAccent,
        brightness: Brightness.dark,
      ),
    );
  }
}