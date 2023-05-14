import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacechat/data/db.dart';
import 'package:spacechat/data/types.dart';
import 'package:spacechat/helpers/socket.dart';
import 'package:spacechat/widgets/chat_card.dart';
import 'package:sqflite/sqflite.dart';

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
  late SocketConnection _socketConnection;
  late Stream<List<Chat>> _chatStream;

  @override
  void initState() {
    super.initState();
    _socketConnection = SocketConnection();
    _socketConnection.initializeSocketConnection();
  }

  Stream<List<Chat>> _getChatStream() async* {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    try {
      final List<Map<String, dynamic>> chats =
          await db.query('chats', orderBy: 'id DESC');

      final List<Chat> chatList = List.generate(chats.length, (index) {
        return Chat(
            id: chats[index]['id'],
            name: chats[index]['name'],
            receiver: chats[index]['receiver'],
            imageUrl: chats[index]['image']);
      });

      yield chatList;

      await for (final chat
          in db.query('chats', orderBy: 'id DESC').asStream()) {
        final List<Chat> updatedChatList = List.generate(chats.length, (index) {
          return Chat(
              id: chat[index]['id'] as String,
              name: chat[index]['name'] as String,
              receiver: chat[index]['receiver'] as String,
              imageUrl: chat[index]['image'] as String?);
        });

        yield updatedChatList;
        updateChats();
      }
    } on DatabaseException catch (e) {
      yield [];
    }
  }

  void updateChats() {
    setState(() {
      _chatStream = _getChatStream();
    });
  }

  Future<List<Chat>> _getChats() async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> chats = await db.query('chats');
    return List.generate(chats.length, (index) {
      return Chat(
          id: chats[index]['id'],
          name: chats[index]['name'],
          receiver: chats[index]['receiver'],
          imageUrl: chats[index]['image']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      appBar: const MyAppBar(
        height: 140,
      ),
      body: StreamBuilder<List<Chat>>(
        stream: _getChatStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('I NOW HAVE ${snapshot.data?.length} CHATS');
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final chat = snapshot.data![index];
                return ChatCard(
                  chatId: chat.id,
                  name: chat.name,
                  receiver: chat.receiver,
                  image: chat.imageUrl,
                  socketConnection: _socketConnection,
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
