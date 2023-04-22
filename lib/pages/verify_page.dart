import 'package:flutter/material.dart';
import 'package:spacechat/widgets/verify_form.dart';

class VerifyPage extends StatelessWidget {
  const VerifyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: 360,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 96,
              ),
              GestureDetector(
                onTap: () => {Navigator.pop(context)},
                child: const Image(
                  image: AssetImage("assets/images/back_icon.png"),
                  height: 16,
                ),
              ),
              const SizedBox(
                height: 96,
              ),
              const Text(
                "Verify code",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                "Enter the code sent to you via to the number",
                style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 40,
              ),
              const VerifyForm(),
            ],
          ),
        ),
      ),
    );
  }
}
