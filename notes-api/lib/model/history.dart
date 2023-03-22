import 'package:conduit_core/conduit_core.dart';

class History extends ManagedObject<_History> implements _History {}

class _History {
  @primaryKey
  int? id;

  @Column()
  String? action;

  @Relate(#note, isRequired: true, onDelete: DeleteRule.cascade)
  int? noteId;

  @Relate(#user, isRequired: true, onDelete: DeleteRule.cascade)
  int? userId;

  @Column()
  DateTime? datacreate;
}
