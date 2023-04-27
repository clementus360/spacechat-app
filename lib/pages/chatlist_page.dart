import 'package:flutter/material.dart';
import 'package:spacechat/data/db.dart';
import 'package:spacechat/data/types.dart';
import 'package:spacechat/widgets/chat_card.dart';

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
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            foregroundImage: Image.asset("assets/images/qrcode_icon.png").image,
          ),
          const SizedBox(
            height: 4,
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Chat",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  Future<List<Chat>> _getChats() async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> _chats = await db.query('chats');

    return List.generate(_chats.length, (index) {
      return Chat(
          id: _chats[index]['id'],
          name: _chats[index]['name'],
          receiver: _chats[index]['receiver'],
          imageUrl: _chats[index]['image']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      appBar: const MyAppBar(
        height: 140,
      ),
      body: FutureBuilder<List<Chat>>(
        future: _getChats(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final chat = snapshot.data![index];
                return ChatCard(
                  id: chat.id,
                  name: chat.name,
                  image: chat.imageUrl,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        child: Image(
          image: Image.asset("assets/images/qrcode_icon.png").image,
          height: 32,
        ),
      ),
    );
  }
}
