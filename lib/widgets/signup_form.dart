import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:spacechat/pages/signin_page.dart';
import 'package:spacechat/pages/verify_page.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Username',
            style: TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: 'Enter a username'),
          ),
          const SizedBox(
            height: 24,
          ),
          const Text(
            'Email',
            style: TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: 'Enter your email'),
          ),
          const SizedBox(
            height: 24,
          ),
          const Text(
            'Phone number',
            style: TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          InternationalPhoneNumberInput(onInputChanged: null),
          const SizedBox(
            height: 160,
          ),
          ElevatedButton(
              onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const VerifyPage()),
                      ),
                    ),
                  },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
              child: const Text(
                "Sign up",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Gilroy',
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?"),
              TextButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const SigninPage()),
                    ),
                  ),
                },
                child: const Text("Log in"),
              )
            ],
          ),
        ],
      ),
    );
  }
}
