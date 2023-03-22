import 'dart:io';

import 'package:apibackend/model/note.dart';
import 'package:conduit_core/conduit_core.dart';

import '../utils/app_response.dart';
import '../utils/app_utils.dart';

class NoteDeleteLogicalController extends ResourceController {
  NoteDeleteLogicalController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.put('id')
  Future<Response> deleteLogicalFinanceData(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.path("id") int id,
    @Bind.query('isDeleted') String isDeleted,
  ) async {
    try {
      final currentUserId = AppUtils.getIdFromHeader(header);
      final note = await managedContext.fetchObjectWithID<Note>(id);
      if (note == null) {
        return AppResponse.ok(message: "Заметка не найдена");
      }
      if (note.user?.id != currentUserId) {
        return AppResponse.ok(message: "Нет доступа к заметке :(");
      }
      bool delorback = true;
      if (isDeleted == "true") {
        delorback = true;
      } else if (isDeleted == "false") {
        delorback = false;
      } else {
        return AppResponse.ok(message: "Введено неверное значение");
      }
      final qDeleteLogicalNote = Query<Note>(managedContext)
        ..where((x) => x.id).equalTo(id)
        ..values.isDeleted = delorback;
      await qDeleteLogicalNote.update();

      await AppUtils.addHistory(managedContext,
          'logical ${delorback ? 'delete' : 'recover'}', id, currentUserId);

      return AppResponse.ok(
          message: "Успешное логическое удаление или восстановление заметки");
    } catch (error) {
      return AppResponse.serverError(error,
          message: "Ошибка логического удаления или восстановления заметки");
    }
  }
}
