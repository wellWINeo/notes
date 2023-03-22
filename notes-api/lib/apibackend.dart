import 'dart:io';
import 'package:apibackend/controllers/auth_controller.dart';
import 'package:apibackend/controllers/history_controller.dart';
import 'package:apibackend/controllers/note_controller.dart';
import 'package:apibackend/controllers/note_paginaition_controller.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:conduit_postgresql/conduit_postgresql.dart';
import 'package:apibackend/controllers/user_controller.dart';

import 'controllers/note_logical_delete.dart';
import 'controllers/token_controller.dart';

class AppService extends ApplicationChannel {
  late final ManagedContext managedContext;

  @override
  Future prepare() {
    final persistentStore = _initDataBase();
    managedContext = ManagedContext(
        ManagedDataModel.fromCurrentMirrorSystem(), persistentStore);
    return super.prepare();
  }

  @override
  Controller get entryPoint => Router()
    ..route('token/[:refresh]').link(
      () => AuthContoler(managedContext),
    )
    ..route('user')
        .link(TokenController.new)!
        .link(() => UserController(managedContext))
    ..route('note/[:id]')
        .link(TokenController.new)!
        .link(() => NoteController(managedContext))
    ..route('note/delete/[:id]')
        .link(TokenController.new)!
        .link(() => NoteDeleteLogicalController(managedContext))
    ..route('note/pagination/[:page]')
        .link(TokenController.new)!
        .link(() => NotePaginationController(managedContext))
    ..route('note/history')
        .link(TokenController.new)!
        .link(() => HistoryController(managedContext));
  PersistentStore _initDataBase() {
    final username = Platform.environment['DB_USERNAME'] ?? 'notes_api';
    final password = Platform.environment['DB_PASSWORD'] ?? 'password123';
    final host = Platform.environment['DB_HOST'] ?? '127.0.0.1';

    final port = int.parse(Platform.environment['DB_PORT'] ?? '5432');

    final databaseName = Platform.environment['DB_NAME'] ?? 'notesdb';

    return PostgreSQLPersistentStore(
        username, password, host, port, databaseName);
  }
}
