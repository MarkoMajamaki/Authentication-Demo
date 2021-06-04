import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/routes.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/services/servicelocator.dart';
import 'package:frontend/views/login_view.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() {
  setupServiceLocator();
  // check if is running on Web
  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    FacebookAuth.i.webInitialize(
      appId: "218571109781941",
      cookie: true,
      xfbml: true,
      version: "v9.0",
    );
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: serviceLocator<NavigationService>().getNavigatorKey(),
      initialRoute: LoginView.route,
      routes: getRoutes(),
      debugShowCheckedModeBanner: false,
      title: 'Authentication-Demo',
      home: LoginView(),
    );
  }
}
