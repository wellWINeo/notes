import 'dart:io';
import 'package:apibackend/model/history.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

abstract class AppUtils {
  const AppUtils._();

  static int getIdFromToken(String token) {
    try {
      final key = Platform.environment["SECRET_KEY"] ?? 'SECRET_KEY';
      final jwtClaim = verifyJwtHS256Signature(token, key);
      return int.parse(jwtClaim["id"].toString());
    } catch (e) {
      rethrow;
    }
  }

  static int getIdFromHeader(String header) {
    try {
      final token = const AuthorizationBearerParser().parse(header);
      final id = getIdFromToken(token ?? "");
      return id;
    } catch (e) {
      rethrow;
    }
  }

  static Future addHistory(
      ManagedContext context, String action, int noteId, int userId) async {
    final qCreateHistory = Query<History>(context)
      ..values.action = action
      ..values.noteId = noteId
      ..values.userId = userId
      ..values.datacreate = DateTime.now();

    await qCreateHistory.insert();
  }
}
