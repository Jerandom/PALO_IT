import 'package:flutter/material.dart';

import '../Class/widgetClass/appBarWidget.dart';
import '../Class/widgetClass/textBoxWidget.dart';
import '../Class/widgetClass/slidePageWidget.dart';

import 'createAccount.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  GestureDetector clickableText(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.blue,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  ElevatedButton clickableButton(String title, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget loginBody(){
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 50.0, right: 50.0, bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/icons/ic_launcher.png", height: 100, width: 100),
              ],
            ),
            const SizedBox(height: 80),
            const TextBoxWidget(
              headerText: "Username",
              hintText: "Example@gmail.com",
              height: 100,
            ),
            const TextBoxWidget(
              headerText: "Password",
              obscureText: true,
              height: 100,
            ),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: clickableButton("Login", () {
                Navigator.pushReplacementNamed(context,  "/imageList");
              }),
            ),
            const SizedBox(height: 16),
            clickableText("Create Account", () {
              Navigator.push(context, SlidePageRoute(widget: const MyCreateAccountPage()));
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: "Login Page",
      ),
      body: loginBody(),
    );
  }
}
