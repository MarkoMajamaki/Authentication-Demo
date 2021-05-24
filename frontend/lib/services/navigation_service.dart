import 'dart:async';

import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigatorKey =
      new GlobalKey<NavigatorState>();

  Function(String, dynamic)? _showDialog;
  Function? _closeDialog;

  ///
  /// Register dialog provider
  ///
  void registerDialogProvider(
      Function(String, dynamic) showDialog, Function closeDialog) {
    _showDialog = showDialog;
    _closeDialog = closeDialog;
  }

  ///
  /// Navigate to new screen
  ///
  Future<dynamic> navigate(String routeName, {dynamic arguments}) {
    return _navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  ///
  /// Navigate to previous screen
  ///
  void goBack({dynamic arguments}) {
    return _navigatorKey.currentState!.pop(arguments);
  }

  ///
  /// Could navigate back
  ///
  Future<bool> canGoBack() {
    return _navigatorKey.currentState!.maybePop();
  }

  ///
  /// Get navigator key
  ///
  GlobalKey<NavigatorState> getNavigatorKey() {
    return _navigatorKey;
  }

  ///
  /// Open dialog
  ///
  Future<dynamic> showDialog(String dialogName, {dynamic arguments}) {
    if (_showDialog == null || _closeDialog == null) {
      throw Exception("DialogProvider is not added to widget tree!");
    }

    return _showDialog!(dialogName, arguments);
  }

  ///
  /// Close dialog
  ///
  void closeDialog({dynamic response}) {
    if (_showDialog == null || _closeDialog == null) {
      throw Exception("DialogProvider is not added to widget tree!");
    }

    _closeDialog!(response: response);
  }
}
