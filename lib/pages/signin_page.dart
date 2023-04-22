import 'package:flutter/material.dart';
import 'package:spacechat/widgets/signin_form.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: 360,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Log in",
                style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "Sign in to your account",
                style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 40,
              ),
              SignInForm(),
            ],
          ),
        ),
      ),
    );
  }
}
