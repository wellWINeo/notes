import 'dart:io';

import 'package:apibackend/model/note.dart';
import 'package:conduit_core/conduit_core.dart';

import '../model/model_response.dart';
import '../utils/app_response.dart';
import '../utils/app_utils.dart';

const PAGE_SIZE = 3;

class NotePaginationController extends ResourceController {
  NotePaginationController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.get("page")
  Future<Response> getPagination(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.path("page") int pageNumber,
  ) async {
    try {
      if (pageNumber <= 0) {
        return Response.notFound(
            body: ModelResponse(
                data: [], message: "Страница не может быть меньше единицы"));
      }
      // Получаем id пользователя из header
      final id = AppUtils.getIdFromHeader(header);

      final qNotePages = Query<Note>(managedContext)
        ..where((x) => x.user!.id).equalTo(id)
        ..where((x) => x.isDeleted).equalTo(false)
        ..sortBy((x) => x.id, QuerySortOrder.ascending)
        ..offset = (pageNumber - 1) * PAGE_SIZE
        ..fetchLimit = PAGE_SIZE;

      final List<Note> list = await qNotePages.fetch();

      if (list.isEmpty) {
        return Response.notFound(
            body: ModelResponse(data: [], message: "Страница пуста"));
      }

      return Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }
}
