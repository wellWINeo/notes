import 'dart:io';

import 'package:apibackend/model/history.dart';
import 'package:apibackend/model/note.dart';
import 'package:conduit_core/conduit_core.dart';

import '../model/model_response.dart';
import '../utils/app_response.dart';
import '../utils/app_utils.dart';

class NoteController extends ResourceController {
  NoteController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.get()
  Future<Response> getNotes(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    //  @Bind.query("page") int page,
  ) async {
    try {
      // Получаем id пользователя из header
      final id = AppUtils.getIdFromHeader(header);

      final qCreateNote = Query<Note>(managedContext)
        ..where((x) => x.user!.id).equalTo(id)
        ..where((x) => x.isDeleted!).equalTo(false);
      //    ..fetchLimit = 3
      //    ..offset = (page-1) * 20;

      final list = await qCreateNote.fetch();

      if (list.isEmpty)
        return Response.notFound(
            body: ModelResponse(data: [], message: "Нет ни одной заметки"));

      return Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

  @Operation.post()
  Future<Response> createNote(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.body() Note note) async {
    try {
      // Получаем id пользователя из header
      final id = AppUtils.getIdFromHeader(header);

      // Создаем запрос для создания финансового отчета передаем id пользователя контент берем из body
      final qCreateNote = Query<Note>(managedContext)
        ..values.noteTitle = note.noteTitle
        ..values.noteDescription = note.noteDescription
        ..values.createDate = DateTime.now()
        ..values.updateDate = DateTime.now()
        ..values.isDeleted = false
        ..values.category = note.category
        //передаем в внешний ключ id пользователя
        ..values.user!.id = id;

      final createdNote = await qCreateNote.insert();

      await AppUtils.addHistory(managedContext, 'create', createdNote.id!, id);

      return AppResponse.ok(message: 'Успешное создание заметки отчета');
    } catch (error) {
      return AppResponse.serverError(error, message: 'Ошибка создания заметки');
    }
  }

  @Operation.put('id')
  Future<Response> updateNote(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path("id") int id,
      @Bind.body() Note bodyNote) async {
    try {
      final currentUserId = AppUtils.getIdFromHeader(header);
      final noteData = await managedContext.fetchObjectWithID<Note>(id);
      if (noteData == null) {
        return AppResponse.ok(message: "Заметка не найдена");
      }
      if (noteData.user?.id != currentUserId) {
        return AppResponse.ok(message: "Нет доступа к заметке");
      }

      final qUpdateNoteData = Query<Note>(managedContext)
        ..where((x) => x.id).equalTo(id)
        ..values.noteTitle = bodyNote.noteTitle ?? noteData.noteTitle
        ..values.noteDescription =
            bodyNote.noteDescription ?? noteData.noteDescription
        ..values.createDate = bodyNote.createDate ?? noteData.createDate
        ..values.updateDate = DateTime.now()
        ..values.isDeleted = false
        //передаем в внешний ключ id пользователя
        ..values.user!.id = currentUserId;

      await qUpdateNoteData.update();

      await AppUtils.addHistory(managedContext, 'update', id, currentUserId);

      return AppResponse.ok(message: 'Заметка успешно обновлена');
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

  @Operation.delete("id")
  Future<Response> deleteNote(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.path("id") int id,
  ) async {
    try {
      final currentUserId = AppUtils.getIdFromHeader(header);
      final noteData = await managedContext.fetchObjectWithID<Note>(id);
      if (noteData == null) {
        return AppResponse.ok(message: "Заметка не найденa");
      }
      if (noteData.user?.id != currentUserId) {
        return AppResponse.ok(message: "Нет доступа к заметке :(");
      }
      final qDeleteNoteData = Query<Note>(managedContext)
        ..where((x) => x.id).equalTo(id);
      await qDeleteNoteData.delete();

      await AppUtils.addHistory(managedContext, 'delete', id, currentUserId);

      return AppResponse.ok(message: "Успешное удаление заметки");
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка удаления заметки");
    }
  }

  @Operation.get("id")
  Future<Response> getNoteDataFromID(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.path("id") int id,
  ) async {
    try {
      final currentUserId = AppUtils.getIdFromHeader(header);
      final noteData = await managedContext.fetchObjectWithID<Note>(id);
      if (noteData == null) {
        return AppResponse.ok(message: "Заметка не найдена");
      }
      if (noteData.user?.id != currentUserId) {
        return AppResponse.ok(message: "Нет доступа к заметке");
      }
      noteData.backing.removeProperty("user");
      return Response.ok(noteData);
    } catch (error) {
      return AppResponse.serverError(error,
          message: "Ошибка получения заметки");
    }
  }
}
