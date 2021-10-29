// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:project2/screens/home.dart';
// ignore: import_of_legacy_library_into_null_safe
import "package:http/http.dart" as http;
// ignore: unused_shown_name
import 'dart:convert' show ascii, base64, json, jsonDecode;

const SERVER_IP = 'https://api.enab.app';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final email = TextEditingController();
  final password = TextEditingController();

  Future<String?> attemptLogIn(String email, String password) async {
    var res = await http.post("$SERVER_IP/api/auth/login",
        body: {"email": email, "password": password});

    Map<String, dynamic> data = jsonDecode(res.body);

    if (res.statusCode == 200) return data['access_token'];
    return null;
  }

  void checkUser() async {
    var jwt = await attemptLogIn(email.text, password.text);
    if (jwt != null) {
      // storage.write(key: "jwt", value: jwt);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MyHomePage.fromBase64(jwt)));
    } else {
      // ignore: avoid_print
      print("An Error Occurred");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(150.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("تسجيل الدخول",
                      style: TextStyle(
                          fontSize: 48.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30.0),
                  TextField(
                    controller: email,
                    decoration: const InputDecoration(
                        labelText: "البريد الالكتروني",
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: password,
                    decoration: const InputDecoration(
                        labelText: "كلمة المرور", border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  // ignore: deprecated_member_use
                  OutlineButton(
                    padding: const EdgeInsets.all(20.0),
                    onPressed: () => checkUser(),
                    child: const Text("تسجيل الدخول"),
                  ),
                ],
              ),
            )));
  }
}
