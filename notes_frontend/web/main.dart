import 'package:ngdart/angular.dart';
import 'package:ngcomponents/angular_components.dart';
import 'package:ngrouter/ngrouter.dart';
import 'package:notes_frontend/app_component.template.dart' as ng;

import 'package:http/http.dart';

import 'main.template.dart' as self;

// Example of a [root injector](https://angulardart.xyz/guide/dependency-injection#root-injector-providers)
// [popupModule] is used in [MaterialTooltipDirective]
@GenerateInjector(
    [popupModule, routerHashModule, routerProviders, ClassProvider(Client)])
final InjectorFactory rootInjector = self.rootInjector$Injector;

void main() {
  runApp(ng.AppComponentNgFactory, createInjector: rootInjector);
}
