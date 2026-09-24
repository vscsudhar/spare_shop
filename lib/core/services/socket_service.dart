import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:spare_shop/app/app.locator.dart';
import 'api_endpoints.dart';
import 'token_service.dart';

class SocketService {
  final TokenService _tokenService;
  io.Socket? _socket;
  final Set<String> _joinedRooms = {};
  final Map<String, List<Function(dynamic)>> _listeners = {};
  bool _isConnecting = false;

  SocketService({TokenService? tokenService})
      : _tokenService = tokenService ?? locator<TokenService>();

  bool get isConnected => _socket?.connected ?? false;

  Future<void> connect() async {
    if (_socket != null && _socket!.connected) return;
    if (_isConnecting) return;

    _isConnecting = true;
    try {
      final token = await _tokenService.getAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint('[SocketService] No token found, skipping connect');
        _isConnecting = false;
        return;
      }

      if (_socket != null) {
        _socket!.dispose();
        _socket = null;
      }

      _socket = io.io(
        ApiEndpoints.socketUrl,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setAuth({'token': token})
            .setExtraHeaders({'Authorization': 'Bearer $token'})
            .setQuery({'token': token})
            .build(),
      );

      _socket!.onConnect((_) {
        debugPrint('[SocketService] Connection established');
        // Re-join all tracked rooms
        for (final room in _joinedRooms) {
          _socket?.emit('room:join', {'roomId': room});
        }
        // Re-attach all tracked listeners
        _listeners.forEach((event, callbacks) {
          for (final cb in callbacks) {
            _socket?.on(event, cb);
          }
        });
      });

      _socket!.onDisconnect((_) {
        debugPrint('[SocketService] Connection disconnected');
      });

      _socket!.onConnectError((err) {
        debugPrint('[SocketService] Connection error: $err');
      });

      _socket!.connect();
    } catch (e) {
      debugPrint('[SocketService] Error in connect: $e');
    } finally {
      _isConnecting = false;
    }
  }

  void joinRequestRoom(String requestId) {
    joinRoom('rare-request:$requestId');
  }

  void leaveRequestRoom(String requestId) {
    leaveRoom('rare-request:$requestId');
  }

  void joinRoom(String room) {
    _joinedRooms.add(room);
    if (_socket != null && _socket!.connected) {
      _socket!.emit('room:join', {'roomId': room});
    } else {
      connect();
    }
  }

  void leaveRoom(String room) {
    _joinedRooms.remove(room);
    if (_socket != null && _socket!.connected) {
      _socket!.emit('room:leave', {'roomId': room});
    }
  }

  void emit(String event, dynamic data) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit(event, data);
    } else {
      connect().then((_) {
        _socket?.emit(event, data);
      });
    }
  }

  void on(String event, Function(dynamic) callback) {
    _listeners.putIfAbsent(event, () => []).add(callback);
    _socket?.on(event, callback);
  }

  void off(String event, [Function(dynamic)? handler]) {
    if (handler != null) {
      _listeners[event]?.remove(handler);
      _socket?.off(event, handler);
    } else {
      _listeners.remove(event);
      _socket?.off(event);
    }
  }

  void disconnect() {
    _joinedRooms.clear();
    _listeners.clear();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
