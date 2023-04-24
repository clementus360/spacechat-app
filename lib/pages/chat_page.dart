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

class ChatBubble extends StatelessWidget {
  final String message;
  final String timestamp;
  final String sender;
  const ChatBubble({
    super.key,
    required this.message,
    required this.timestamp,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: 16, right: sender == "1" ? 0 : 32, left: sender == "1" ? 32 : 0),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: sender == "1" ? Colors.blue : Colors.grey.shade300,
      ),
      child: Column(
          crossAxisAlignment:
              sender == "1" ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: sender == "1" ? Colors.white : Colors.black,
                fontFamily: 'Gilroy',
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              timestamp,
              style: TextStyle(
                color: sender == "1" ? Colors.white : Colors.black,
                fontFamily: 'Gilroy',
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),
            ),
          ]),
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const MyAppBar(
        height: 140,
      ),
      body: ListView(
        reverse: true,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        children: const [
          ChatBubble(
              message:
                  "Hello we are going to go get a few telephones and a candy bar to help you become the man you always wanted to be",
              timestamp: "20:23",
              sender: "1"),
          ChatBubble(
              message:
                  "Hello, that is not what i wanted to hear, because if tou want to mess with me i will not accept whatever you say",
              timestamp: "20:24",
              sender: "2"),
          ChatBubble(message: "How are you", timestamp: "20:26", sender: "1"),
          ChatBubble(message: "I am fine", timestamp: "20:29", sender: "2"),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
