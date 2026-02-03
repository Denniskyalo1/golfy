import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:golfy/user_prefs.dart';

class AuthCheckProvider extends ChangeNotifier {
  bool _checked = false;
  bool get checked => _checked;

  Future<void> checkLoginStatus(BuildContext context) async {
    if (_checked) return;

    final results = await Future.wait([
      UserPrefs.getUserName(),
      UserPrefs.getUserEmail(),
    ]);

    final userName = results[0];
    final userEmail = results[1];

    await Future.delayed(const Duration(milliseconds: 300));

    FlutterNativeSplash.remove();

    final route = (userName != null && userEmail != null)
        ? '/homePage'
        : '/landing';

    _checked = true;

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, route);
    }
  }
}
