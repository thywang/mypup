import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:my_pup_simple/bootstrap.dart';
import 'package:my_pup_simple/firebase_options.dart';
import 'package:my_pup_simple/puppy_profile/data/puppy_preferences.dart';
import 'package:my_pup_simple/src/app/app.dart';
import 'package:my_pup_simple/src/localization/string_hardcoded.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize shared preferences
  await PuppyPreferences.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // turn off the # in the URLs on the web
  usePathUrlStrategy();
  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  registerErrorHandlers();
  // * Entry point of the app

  await bootstrap(() => const App());
}

void registerErrorHandlers() {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint(error.toString());
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('An error occurred'.hardcoded),
      ),
      body: Center(child: Text(details.toString())),
    );
  };
}
