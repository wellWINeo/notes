import 'dart:async';
import 'dart:developer';

import 'package:ngdart/angular.dart';
import 'package:ngcomponents/angular_components.dart';
import 'package:notes_frontend/src/models/note.dart';
import 'package:notes_frontend/src/services/note.service.dart';

@Component(
    selector: 'notes',
    styleUrls: ['notes.component.css'],
    templateUrl: 'notes.component.html',
    directives: [
      MaterialCheckboxComponent,
      MaterialFabComponent,
      MaterialIconComponent,
      materialInputDirectives,
      MaterialTooltipDirective,
      NgFor,
      NgIf,
    ],
    providers: [ClassProvider(NoteService)])
class NotesComponent implements OnInit {
  List<Note> items = [];

  String noteTitle = '';
  String noteDescription = '';
  String noteCategory = '';

  NoteService _noteService;

  NotesComponent(this._noteService);

  @override
  Future<void> ngOnInit() async {
    this.getAll();
  }

  Future getAll() async {
    this.items = await this._noteService.getAll();
  }

  Future add() async {
    await this._noteService.create(noteTitle, noteDescription, noteCategory);
  }

  Future remove(int index) async {}
}
