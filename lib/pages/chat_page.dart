import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  const MyAppBar({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 80,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 3.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => {Navigator.pop(context)},
            child: const Image(
              image: AssetImage("assets/images/back_icon.png"),
              height: 16,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          CircleAvatar(
            radius: 24,
            foregroundImage: Image.asset("assets/images/qrcode_icon.png").image,
          ),
          const SizedBox(
            width: 16,
          ),
          const Text(
            "User Name",
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.call,
            color: Colors.blue,
            size: 32,
          ),
          const SizedBox(
            width: 16,
          ),
          const Icon(
            Icons.videocam,
            color: Colors.blue,
            size: 32,
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 24,
        left: 16,
        right: 16,
        bottom: 32,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, -4),
            blurRadius: 3.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.image),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(40),
                ),
                hintText: 'Enter your message',
                suffixIcon: const Icon(Icons.mic),
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          IconButton(
            onPressed: () => null,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: MyAppBar(
        height: 140,
      ),
      body: Text("Welcome"),
      bottomNavigationBar: BottomBar(),
    );
  }
}
