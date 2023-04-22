import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 40,
            foregroundImage: Image.asset("assets/images/qrcode_icon.png").image,
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "User Name",
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Message placeholder",
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          const Icon(
            Icons.check_sharp,
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}
