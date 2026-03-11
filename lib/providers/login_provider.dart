import 'package:flutter/material.dart';
import '../auth_services.dart';
import '../user_prefs.dart';

class LoginProvider extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnack(context, 'Please fill in all the fields');
      return;
    }

    _setLoading(true);

    try {
      final result = await AuthService.login(
        email: email,
        password: password,
      );

      final status = result['status'];
      final body = result['body'];

      if (status == 200 && body['user'] != null) {
        final user = body['user'];
        final token = body['token'];

        await UserPrefs.saveUser(
          name: user['name'] ?? '',
          email: user['email'] ?? '',
          role: user['role'] ?? '',
          token: token ?? '',
        );
        if(!context.mounted) return;
        _showSuccessDialog(context);
        return;
      }
      if(!context.mounted) return;
      _showSnack(context, body['message'] ?? 'Login failed');
    } catch (e) {
      debugPrint('Login error: $e');
      _showSnack(context, 'Server error. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _showSnack(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Log in successful!'),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/homePage',
                    (route) => false,
              );
            },
            child: Text(
              'Ok',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
