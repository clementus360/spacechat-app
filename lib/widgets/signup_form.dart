// Dart imports
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

// External dependencies
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Internal
import 'package:spacechat/pages/signin_page.dart';
import 'package:spacechat/pages/verify_page.dart';
import 'package:spacechat/utils/uri.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  late PhoneNumber _phoneNumber;

  final emailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your name";
              }

              return null;
            },
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
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter an email";
              }
              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
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
          InternationalPhoneNumberInput(
            onInputChanged: (value) => {_phoneNumber = value},
            initialValue: PhoneNumber(
              isoCode: Platform.localeName.split('_').last,
            ),
            ignoreBlank: false,
          ),
          const SizedBox(
            height: 120,
          ),
          ElevatedButton(
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                if (_formKey.currentState!.validate()) {
                  await signUp(nameController.text, emailController.text,
                          _phoneNumber.phoneNumber)
                      .then((value) => {
                            if (value.statusCode == 200)
                              {
                                prefs.setString("phoneNumber",
                                    _phoneNumber.phoneNumber ?? ""),
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => const VerifyPage()),
                                  ),
                                )
                              }
                            else
                              {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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

Future<http.Response> signUp(name, email, phone) {
  var uri = ApiEndpoints.REGISTER;
  print(uri);
  return http.post(
    Uri.parse(uri),
    body: jsonEncode(
      <String, String>{
        'name': name,
        'email': email,
        'phone': phone,
      },
    ),
  );
}
