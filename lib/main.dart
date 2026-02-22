import 'package:flutter/material.dart';
import 'package:konektz/chat_page.dart';
import 'package:konektz/core/theme.dart';
import 'package:konektz/login_page.dart';
import 'package:konektz/message_page.dart';
import 'package:konektz/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Konektz',
      theme: AppTheme.darkTheme,
      home: const LoginPage(),
    );
  }
}
