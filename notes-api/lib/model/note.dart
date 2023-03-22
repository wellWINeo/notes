import 'package:apibackend/model/user.dart';
import 'package:conduit_core/conduit_core.dart';

class Note extends ManagedObject<_Note> implements _Note {}

class _Note {
  @primaryKey
  int? id;

  @Column(indexed: true)
  String? noteTitle;

  @Column(indexed: false)
  String? noteDescription;

  @Column(indexed: false)
  DateTime? createDate;

  @Column(indexed: false)
  DateTime? updateDate;

  @Column(indexed: false)
  bool? isDeleted;

  @Column(indexed: true)
  String? category;

  @Relate(#note, isRequired: true, onDelete: DeleteRule.cascade)
  User? user;
}
