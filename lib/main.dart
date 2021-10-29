import 'package:flutter/material.dart';
import 'package:project2/screens/login.dart';
import 'dart:convert';

import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<String> get jwtOrEmpty async {
    // var jwt = await storage.read(key: "jwt");
    // if(jwt == null) return "";
    // return jwt;
    return "null";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            if (snapshot.data != "") {
              var str = snapshot.data.toString();
              var jwt = str.split(".");

              if (jwt.length != 3) {
                return const Login();
              } else {
                var payload = json.decode(
                    ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                    .isAfter(DateTime.now())) {
                  return MyHomePage(str, payload);
                } else {
                  return const Login();
                }
              }
            } else {
              return const Login();
            }
          }),
    );
  }
}
