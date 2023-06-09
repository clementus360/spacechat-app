import 'dart:async';
import 'dart:convert';
import 'package:spacechat/data/db.dart';
import 'package:spacechat/data/types.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacechat/utils/uri.dart';

class SocketConnection {
  static final SocketConnection _instance = SocketConnection._internal();

  factory SocketConnection() {
    return _instance;
  }

  SocketConnection._internal() {
    _initialize();
  }

  late String _token;
  late String _userId;
  late WebSocketChannel _channel;
  late String _ticket;

  bool _isConnected = false;
  bool _isConnecting = false;

  final StreamController<Message> _messageStreamController =
      StreamController<Message>.broadcast();
  Stream<Message> get _onMessage => _messageStreamController.stream;

  Future<void> _initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString("phoneNumber")!;
    _token = prefs.getString("token")!;
    _ticket = await _fetchTicket();
  }

  Future<String> _fetchTicket() async {
    var uri = "${ApiEndpoints.AUTHORIZE}/$_userId";
    final response = await http.get(Uri.parse(uri), headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      return Uri.encodeComponent(utf8.decode(response.bodyBytes));
    } else {
      print(uri);
      throw Exception('Failed to fetch SessionId');
    }
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      initializeSocketConnection();
    });
  }

  void dispose() {
    _messageStreamController.close();
    if (_isConnected) {
      _channel.sink.close();
      _isConnected = false;
    }
  }

  Future<void> initializeSocketConnection() async {
    print("initializing socket.......");
    if (_isConnected || _isConnecting) {
      return;
    }

    _isConnecting = true;

    try {
      final uri = Uri.parse('${ApiEndpoints.SOCKET}/$_userId?ticket=$_ticket');
      _channel = WebSocketChannel.connect(uri);
      _isConnected = true;
      _isConnecting = false;

      // Timer.periodic(const Duration(minutes: 1), (timer) {
      //   if (!_isConnected) {
      //     _reconnect();
      //   }
      // });

      _channel.stream.listen(
        (message) {
          final jsonMessage = jsonDecode(message);
          final Message messageObj = Message.fromJson(jsonMessage);
          _messageStreamController.add(messageObj);
          print(jsonMessage);
          createChat(messageObj);
          addMessageToDB(messageObj);
        },
        onError: (error) {
          _isConnected = false;
          _reconnect();
        },
      );
    } catch (error) {
      _isConnected = false;
      _isConnecting = false;
      print("error connecting");
      _reconnect();
    }
  }

  Future<http.Response> getUserName(String userId) {
    var uri = '${ApiEndpoints.USERNAME}/$userId';
    return http.get(
      Uri.parse(uri),
    );
  }

  Future<void> createChat(Message message) async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    final result =
        await db.query("chats", where: 'id = ?', whereArgs: [message.chatId]);

    print('RESULT = ${result.isEmpty}');

    if (result.isEmpty) {
      try {
        final response = await getUserName(message.sender);
        if (response.statusCode == 200) {
          print("it workss");
          final body = json.decode(response.body);
          final userName = body["username"];
          print('NAME: ${userName}');
          db.insert('chats', {
            'id': message.chatId,
            'name': userName,
            'receiver': message.sender
          });
        } else {
          print("failed to get chat");
        }
      } catch (err) {
        print("Failed to fetch username");
        return;
      }
    }
  }

  Future<void> addMessageToDB(Message message) async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    await db.insert("messages", {
      'id': message.id,
      'payload': message.payload,
      'chatId': message.chatId,
      'receiver': message.receiver,
      'sender': message.sender,
      'timestamp': message.timestamp.toIso8601String(),
    });
  }

  void sendMessage(Message message) {
    print(_isConnected);
    if (!_isConnected) {
      _reconnect();
      throw Exception('Socket connection is not established');
    }

    print(message.payload);

    final jsonMessage = jsonEncode({
      'id': message.id,
      'payload': message.payload,
      'chatId': message.chatId,
      'sender': message.sender,
      'receiver': message.receiver,
      'timestamp': message.timestamp.toIso8601String(),
    });

    _channel.sink.add(jsonMessage);
    addMessageToDB(message);
  }
}
