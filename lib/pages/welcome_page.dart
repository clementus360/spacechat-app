import 'package:flutter/material.dart';
import 'package:spacechat/pages/signup_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: SizedBox(
            width: 360,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Image(
                  image: AssetImage(
                      "assets/images/image0_1024_1024_watermark-3-removebg-preview.png"),
                ),
                const SizedBox(
                  height: 24,
                ),
                Column(
                  children: const <Widget>[
                    Text(
                      "Welcome to SpaceChat",
                      style: TextStyle(
                        fontSize: 32,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      " Because you really needed another chat app to ignore your messages on.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                    onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => const SignupPage()),
                            ),
                          ),
                        },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Gilroy',
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ))
              ],
            ),
          )),
    );
  }
}
