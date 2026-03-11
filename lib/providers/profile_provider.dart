import 'package:flutter/material.dart';
import '../user_prefs.dart';

class ProfileProvider extends ChangeNotifier {
  String userName = '';
  String userEmail = '';
  String userToken = '';
  bool isLoading = true;

  ProfileProvider() {
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    final results = await Future.wait([
      UserPrefs.getUserName(),
      UserPrefs.getUserEmail(),
      UserPrefs.getAuthToken(),
    ]);

    userName = results[0] ?? '';
    userEmail = results[1] ?? '';
    userToken = results[2] ?? '';

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await UserPrefs.clearUser();
  }
}
