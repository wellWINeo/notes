import 'dart:convert';
import 'dart:developer';

import 'package:ngdart/angular.dart';
import 'package:http/http.dart';
import 'package:notes_frontend/src/models/note.dart';
import 'package:notes_frontend/src/services/auth.service.dart';

@Injectable()
class NoteService {
  static final _baseUrl = 'http://localhost:8081/note';

  final Client _client;
  final AuthService _authService;

  NoteService(this._client, this._authService) {}

  Map<String, String> _getHeaders() {
    final token = this._authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token,
    };
  }

  Future create(String title, String description, String category) async {
    await this._client.post(Uri.parse(_baseUrl),
        headers: _getHeaders(),
        body: json.encode({
          "noteTitle": title,
          "noteDescription": description,
          "category": category,
        }));
  }

  Future<List<Note>> getAll() async {
    final response = await this
        ._client
        .get(Uri.parse(_baseUrl + '/pagination/1'), headers: _getHeaders());
    debugger();
    List<dynamic> values = json.decode(response.body);

    return List<Note>.from(values.map((e) => Note.fromJson(e)));
  }
}
