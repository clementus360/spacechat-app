import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  final int duration;
  final Widget goToPage;

  const SplashPage({super.key, required this.goToPage, required this.duration});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: duration), () {
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => goToPage)));
    });

    return Scaffold(
      body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: const Text(
            "Spacechat",
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w700,
                fontSize: 40,
                fontFamily: 'Gilroy'),
          )),
    );
  }
}
