import 'dart:developer';
import 'dart:io';
import 'package:apibackend/apibackend.dart' as apibackend;
import 'package:apibackend/apibackend.dart';
import 'package:conduit/conduit.dart';


void main(List<String> arguments) async {
 
 final port = int.parse(Platform.environment["Port"] ?? '8080');

 final service = Application<AppService>()..options.port = port;
 
 await service.start(numberOfInstances: 3, consoleLogging: true);
}
