import 'package:flutter/material.dart';
import 'package:message/views/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {        
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
          @override
          Widget build(BuildContext context) {
            return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                
                primarySwatch: Colors.blue,
              ),
              home: Login()
            );
          }          
}
