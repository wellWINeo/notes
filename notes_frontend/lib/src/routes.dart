import 'package:ngrouter/ngrouter.dart';

import 'route_paths.dart';
import './components/login/login.component.template.dart' as login_template;
import './components/notes/notes.component.template.dart' as notes_template;

export './route_paths.dart';

class Routes {
  static final login = RouteDefinition(
      routePath: RoutePaths.login,
      component: login_template.LoginComponentNgFactory);

  static final notes = RouteDefinition(
      routePath: RoutePaths.notes,
      component: notes_template.NotesComponentNgFactory);

  static final index =
      RouteDefinition.redirect(path: '', redirectTo: RoutePaths.login.toUrl());

  static final all = <RouteDefinition>[index, login, notes];
}
