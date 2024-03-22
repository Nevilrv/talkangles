import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketConnection {
  static IO.Socket? socket;

  static void connectSocket(Function onConnect) {
    socket = IO.io(
        'https://talkangels-api.onrender.com/',
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect()
            .enableForceNew() // disable auto-connection
            .build());
    socket!.connect();
    socket!.onConnect((_) {
      log('ChatSocketManager connected');
      onConnect();
    });

    socket?.onConnecting((data) => print("ChatSocketManager onConnecting $data"));
    socket?.onConnectError((data) => print("ChatSocketManager onConnectError $data"));
    socket?.onError((data) => print("ChatSocketManager onError $data"));
    socket?.onDisconnect((data) => print("ChatSocketManager onDisconnect $data"));
  }

  static void socketDisconnect() {
    socket?.onDisconnect((data) => print("ChatSocketManager onDisconnect $data"));
  }
}
