import 'dart:async';

import 'package:ngdart/di.dart';

// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class TodoListService {
  List<String> mockTodoList = <String>[];

  Future<List<String>> getTodoList() async => mockTodoList;
}
