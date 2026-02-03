import 'package:flutter/material.dart';
import '../user_prefs.dart';

class HomePageProvider extends ChangeNotifier {
  String userName = '';
  bool isLoading = true;

  HomePageProvider() {
    loadUserName();
  }

  Future<void> loadUserName() async {
    final name = await UserPrefs.getUserName();
    userName = name ?? '';
    isLoading = false;
    notifyListeners();
  }

  bool get isLoggedIn => userName.isNotEmpty;

  Future<void> logout() async {
    await UserPrefs.clearUser();
  }
}
