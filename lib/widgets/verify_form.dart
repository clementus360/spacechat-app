import 'package:flutter/material.dart';
import 'package:spacechat/pages/signin_page.dart';
import 'package:pinput/pinput.dart';

class VerifyForm extends StatefulWidget {
  const VerifyForm({super.key});

  @override
  State<VerifyForm> createState() => _VerifyFormState();
}

class _VerifyFormState extends State<VerifyForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Pinput(
            length: 6,
          ),
          const SizedBox(
            height: 32,
          ),
          const Center(
            child: Text(
              "Time remaining: 1:49",
              style: TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          ElevatedButton(
            onPressed: () => null,
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
            onPressed: null,
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
