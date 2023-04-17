import 'package:flutter/material.dart';
import 'package:spacechat/pages/splash_page.dart';
import 'package:spacechat/pages/welcome_page.dart';

void main() {
  runApp(const MaterialApp(
    home: SplashPage(
      duration: 3,
      goToPage: WelcomePage(),
    ),
  ));
}
