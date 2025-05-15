import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'URL Launcher',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  final String link = "https://maps.app.goo.gl/CrA4yUvx7mMKrPVt6";

  Future<void> _launchInBrowser(Uri url) async {
    !await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final Uri toLaunch = Uri(
        scheme: 'https', host: 'maps.app.goo.gl', path: 'CrA4yUvx7mMKrPVt6');
    return Scaffold(
      appBar: AppBar(),
      body: ElevatedButton(
        onPressed: () async => await _launchInBrowser(toLaunch),
        child: const Text('Launch in browser'),
      ),
    );
  }
}
