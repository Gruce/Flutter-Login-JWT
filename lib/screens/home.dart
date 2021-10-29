// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';
import "package:http/http.dart" as http;

import 'package:flutter/material.dart';

// ignore: constant_identifier_names
const SERVER_IP = 'https://api.enab.app';

class MyHomePage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MyHomePage(this.jwt, this.payload);

  factory MyHomePage.fromBase64(String jwt) => MyHomePage(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Home Page")),
        body: Center(
          child: FutureBuilder(
              future: http.read('$SERVER_IP/api/auth/user',
                  headers: {"Authorization": 'Bearer ' + jwt}),
              builder: (context, snapshot) => snapshot.hasData
                  ? Column(
                      children: <Widget>[
                        Text(
                          json.decode(snapshot.data.toString())['name'],
                          style: const TextStyle(fontSize: 48.0),
                        ),
                        // Text(snapshot.data, style: Theme.of(context).textTheme.display1)
                      ],
                    )
                  : snapshot.hasError
                      ? const Text("An error occurred")
                      : const CircularProgressIndicator()),
        ),
      );
}
