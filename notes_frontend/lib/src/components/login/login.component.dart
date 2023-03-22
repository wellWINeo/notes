import 'dart:async';

import 'package:ngdart/angular.dart';
import 'package:ngcomponents/angular_components.dart';
import 'package:ngrouter/ngrouter.dart';
import 'package:notes_frontend/src/models/user.dart';
import 'package:notes_frontend/src/routes.dart';

import '../../services/auth.service.dart';

@Component(
    selector: 'login',
    styleUrls: ['login.component.css'],
    templateUrl: 'login.component.html',
    directives: [
      NgIf,
      materialInputDirectives,
      MaterialCheckboxComponent,
      MaterialButtonComponent,
    ],
    providers: [ClassProvider(AuthService)])
class LoginComponent implements OnInit {
  bool isRegister = false;

  String email = '';
  String username = '';
  String password = '';

  final AuthService _authService;
  final Router _router;

  LoginComponent(this._authService, this._router);

  @override
  void ngOnInit() {
    final token = this._authService.getToken();
    if (token != null) {
      this._goToNotes();
    }
  }

  Future click() async {
    if (isRegister) {
      await this._authService.register(new User(email, username, password));
    } else {
      await this._authService.auth(username, password);
    }
    this._goToNotes();
  }

  _goToNotes() {
    this._router.navigate(RoutePaths.notes.toUrl());
  }
}
