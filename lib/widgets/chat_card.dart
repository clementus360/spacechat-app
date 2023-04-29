import 'package:flutter/material.dart';
import 'package:spacechat/pages/chat_page.dart';

class ChatCard extends StatelessWidget {
  final int id;
  final String name;
  final String? image;
  const ChatCard(
      {super.key, required this.id, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => ChatPage(
                  name: name,
                  id: id,
                )),
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
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    id.toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
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
