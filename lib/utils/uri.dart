class ApiEndpoints {
  static const String AUTH_BASE_URL = "http://192.168.1.108:3000";
  // static const String AUTH_BASE_URL = "http://192.168.1.69:3000";
  static const String LOGIN = "$AUTH_BASE_URL/api/login";
  static const String REGISTER = "$AUTH_BASE_URL/api/register";
  static const String VERIFY = "$AUTH_BASE_URL/api/verify";
  static const String AUTHORIZE = "$AUTH_BASE_URL/api/authorize";
  // static const String CHAT_BASE_URL = "http://192.168.1.69:3002";
  // static const String SOCKET = "ws://192.168.1.69:3002/api/socket";
  static const String CHAT_BASE_URL = "http://192.168.1.108:3002";
  static const String SOCKET = "ws://192.168.1.108:3002/api/socket";
}
