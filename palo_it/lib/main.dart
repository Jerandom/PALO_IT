import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Pages/login.dart';
import 'Pages/imageList.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyLoginPage(),
      routes: {
        "/login": (context) => const MyLoginPage(),
        "/imageList": (context) => const MyImageListPage(),
      },
    );
  }
}
