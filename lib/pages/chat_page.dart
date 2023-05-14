import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:spacechat/data/db.dart';
import 'package:spacechat/data/types.dart';
import 'package:spacechat/helpers/socket.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final name;
  final double height;
  const MyAppBar({super.key, required this.height, required this.name});

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
          Text(
            name,
            style: const TextStyle(
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

class BottomBar extends StatefulWidget {
  final String chatId;
  final SocketConnection socketConnection;
  final String receiver;
  final updateMessages;
  const BottomBar({
    super.key,
    required this.chatId,
    required this.receiver,
    required this.socketConnection,
    required this.updateMessages,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final _formKey = GlobalKey<FormState>();
  final messageController = TextEditingController();

  Future<String> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("phoneNumber")!;
  }

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
              key: _formKey,
              controller: messageController,
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
            onPressed: () async {
              var uuid = const Uuid();
              final message = Message(
                id: uuid.v4(),
                payload: messageController.text,
                chatId: widget.chatId,
                sender: await getUserId(),
                receiver: widget.receiver,
                timestamp: DateTime.now(),
              );
              widget.socketConnection.sendMessage(message);
              widget.updateMessages();
              messageController.text = '';
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final DateTime timestamp;
  final String sender;
  const ChatBubble({
    super.key,
    required this.message,
    required this.timestamp,
    required this.sender,
  });

  Future<String> _getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("phoneNumber") ?? '';
    return userId;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _getUserId(),
        builder: (context, snapshot) {
          final userId = snapshot.data ?? '';
          return Container(
            margin: EdgeInsets.only(
                top: 16,
                right: sender == userId ? 0 : 32,
                left: sender == userId ? 32 : 0),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              color: sender == userId ? Colors.blue : Colors.grey.shade300,
            ),
            child: Column(
                crossAxisAlignment: sender == userId
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: sender == userId ? Colors.white : Colors.black,
                      fontFamily: 'Gilroy',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    DateFormat.Hm().format(timestamp),
                    style: TextStyle(
                      color: sender == userId ? Colors.white : Colors.black,
                      fontFamily: 'Gilroy',
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ]),
          );
        });
  }
}

class ChatPage extends StatefulWidget {
  final String name;
  final String chatId;
  final String receiver;
  final SocketConnection socketConnection;

  const ChatPage({
    Key? key,
    required this.chatId,
    required this.name,
    required this.receiver,
    required this.socketConnection,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Stream<List<Message>> _messagesStream;

  _ChatPageState() {
    _messagesStream = _getMessages();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Stream<List<Message>> _getMessages() async* {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    try {
      final List<Map<String, dynamic>> messages = await db.query('messages',
          where: 'chatId = ?',
          whereArgs: [widget.chatId],
          orderBy: 'timestamp DESC');

      final List<Message> messagesList =
          List.generate(messages.length, (index) {
        return Message(
          id: messages[index]['id'],
          payload: messages[index]['payload'],
          chatId: messages[index]['chatId'],
          sender: messages[index]['sender'],
          receiver: messages[index]['receiver'],
          timestamp: DateTime.parse(messages[index]['timestamp']),
        );
      });

      // Yield the messages list to the stream
      yield messagesList;

      // Listen for changes in the messages table and yield new messages
      await for (final message in db
          .query('messages',
              where: 'chatId = ?',
              whereArgs: [widget.chatId],
              orderBy: 'timestamp DESC')
          .asStream()) {
        final List<Message> updatedMessagesList =
            List.generate(message.length, (index) {
          return Message(
            id: message[index]['id'] as String,
            payload: message[index]['payload'] as String,
            chatId: message[index]['chatId'] as String,
            sender: message[index]['sender'] as String,
            receiver: message[index]['receiver'] as String,
            timestamp: DateTime.parse(message[index]['timestamp'] as String),
          );
        });
        yield updatedMessagesList;
        updateMessages();
      }
    } on DatabaseException catch (e) {
      yield [];
    } finally {
      // await db.close();
    }
  }

  void updateMessages() {
    setState(() {
      _messagesStream = _getMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(
        builder: (context) => Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: MyAppBar(
            name: widget.name,
            height: 140,
          ),
          body: StreamBuilder<List<Message>>(
            stream: _messagesStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  reverse: true,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    final message = snapshot.data![index];
                    return ChatBubble(
                        message: message.payload,
                        timestamp: message.timestamp,
                        sender: message.sender);
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          bottomNavigationBar: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              viewInsets: EdgeInsets.zero,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: BottomBar(
                chatId: widget.chatId,
                receiver: widget.receiver,
                socketConnection: widget.socketConnection,
                updateMessages: updateMessages,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
