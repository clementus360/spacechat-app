import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;

import 'package:spacechat/pages/chatlist_page.dart';
import 'package:spacechat/utils/uri.dart';
import 'package:spacechat/widgets/signin_form.dart';
import 'package:spacechat/widgets/timer.dart';

class VerifyForm extends StatefulWidget {
  const VerifyForm({super.key});

  @override
  State<VerifyForm> createState() => _VerifyFormState();
}

class _VerifyFormState extends State<VerifyForm> {
  final _formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();

  CountdownTimer timer = CountdownTimer();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Pinput(
            controller: codeController,
            length: 6,
          ),
          const SizedBox(
            height: 32,
          ),
          const Center(
            child: CountdownTimer(),
          ),
          const SizedBox(
            height: 24,
          ),
          ElevatedButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              final phoneNumber = prefs.getString("phoneNumber");

              if (_formKey.currentState!.validate()) {
                await verifyCode(codeController.text, phoneNumber)
                    .then((value) async {
                  if (value.statusCode == 200) {
                    // Get token from response
                    Map<String, dynamic> data = json.decode(value.body);

                    // Set token to localstorage for later use
                    prefs.setString("token", data['token']);

                    // // remove number from local storage for security
                    // prefs.remove("phoneNumber");

                    // move to the chatlist page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const ChatListPage()),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(value.body),
                      duration: const Duration(seconds: 2),
                    ));
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
              "Verify",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Gilroy',
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              final phoneNumber = prefs.getString("phoneNumber");
              await signIn(phoneNumber).then((value) => {
                    if (value.statusCode == 200)
                      {
                        timer.resetTimer(60),
                      }
                    else
                      {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(value.body),
                          duration: const Duration(seconds: 2),
                        ))
                      }
                  });
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16))),
            child: const Text(
              "Resend code",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Gilroy',
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

Future<http.Response> verifyCode(otpCode, phoneNumber) async {
  var uri = ApiEndpoints.VERIFY;
  return http.post(
    Uri.parse(uri),
    body: jsonEncode(
      <String, String>{
        'phoneNumber': phoneNumber,
        'otpCode': otpCode,
      },
    ),
  );
}
