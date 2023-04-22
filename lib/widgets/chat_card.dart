import 'package:flutter/material.dart';
import 'package:spacechat/pages/chat_page.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => const ChatPage()),
          ),
        ),
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 32,
              foregroundImage:
                  Image.asset("assets/images/qrcode_icon.png").image,
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
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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
            Column(
              children: const [
                Text(
                  "20:32",
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Icon(
                  Icons.check_sharp,
                  color: Colors.blue,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
