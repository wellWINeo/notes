import 'dart:convert';
import 'dart:html';

import 'package:http/http.dart';
import 'package:ngdart/angular.dart';

import '../models/user.dart';

@Injectable()
class AuthService {
  static final _header = {'Content-Type': 'application/json'};
  static final _baseUrl = 'http://localhost:8081/token';

  final Client _client;

  String token;

  AuthService(this._client);

  Future<String> register(User user) async {
    try {
      final response = await this._client.put(Uri.parse(_baseUrl),
          headers: _header,
          body: json.encode({
            'username': user.userName,
            'email': user.email,
            'password': user.password,
          }));
      this.token = json.decode(response.body)['data']['accessToken'];
      this._setToken(token);
      return this.token;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> auth(String username, String password) async {
    try {
      final response = await this._client.post(Uri.parse(_baseUrl),
          headers: _header,
          body: json.encode({'username': username, 'password': password}));
      this.token = json.decode(response.body)['data']['accessToken'];
      this._setToken(token);
      return this.token;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _setToken(String token) {
    window.localStorage['access_token'] = token;
  }

  String getToken() {
    return window.localStorage['access_token'] ?? '';
  }
}
