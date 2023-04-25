import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:spacechat/pages/signup_page.dart';
import 'package:spacechat/pages/verify_page.dart';
import 'package:spacechat/utils/uri.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  late PhoneNumber _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phone number',
            style: TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          InternationalPhoneNumberInput(
            onInputChanged: (value) => {_phoneNumber = value},
            initialValue: PhoneNumber(
              isoCode: Platform.localeName.split('_').last,
            ),
            ignoreBlank: false,
          ),
          const SizedBox(
            height: 160,
          ),
          ElevatedButton(
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                if (_formKey.currentState!.validate()) {
                  await signIn(_phoneNumber.phoneNumber).then((value) => {
                        if (value.statusCode == 200)
                          {
                            prefs.setString(
                                "phoneNumber", _phoneNumber.phoneNumber ?? ""),
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => const VerifyPage()),
                              ),
                            )
                          }
                        else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(value.body),
                              duration: const Duration(seconds: 2),
                            ))
                          }
                      });
                }
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
              child: const Text(
                "Log in",
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
                      builder: ((context) => const SignupPage()),
                    ),
                  ),
                },
                child: const Text("Sign up"),
              )
            ],
          ),
        ],
      ),
    );
  }
}

Future<http.Response> signIn(phone) {
  var uri = ApiEndpoints.LOGIN;
  return http.post(
    Uri.parse(uri),
    body: jsonEncode(
      <String, String>{
        'phone': phone,
      },
    ),
  );
}
