import 'package:ngdart/angular.dart';
import 'package:ngrouter/ngrouter.dart';
import 'package:notes_frontend/src/routes.dart';
import 'package:notes_frontend/src/services/auth.service.dart';

import './src/components/notes/notes.component.dart';

// AngularDart info: https://angulardart.xyz
// Components info: https://angulardart.xyz/components
//
// (If the links still point to the old Dart-lang repo, go here:
// https://pub.dev/ngcomponents)

@Component(
    selector: 'my-app',
    styleUrls: ['app_component.css'],
    templateUrl: 'app_component.html',
    directives: [routerDirectives, NotesComponent],
    providers: [ClassProvider(AuthService)],
    exports: [RoutePaths, Routes])
class AppComponent {}
