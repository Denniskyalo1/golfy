import 'package:flutter/material.dart';
import '../auth_services.dart';
import '../user_prefs.dart';

class RegisterProvider extends ChangeNotifier {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _selectedRole;
  String? get selectedRole => _selectedRole;

  static const List<String> roles = [
    'player',
    'manager',
    'caddie',
  ];

  void setRole(String? role) {
    _selectedRole = role;
    notifyListeners();
  }

  String formatRoleName(String role) {
    if (role == 'manager') return 'Course Manager';
    return role[0].toUpperCase() + role.substring(1);
  }

  Future<void> register(BuildContext context) async {
    final name = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = passwordConfirmController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnack(context, 'Please fill in all the fields');
      return;
    }

    if (password != confirmPassword) {
      _showSnack(context, 'Passwords do not match. Please try again');
      return;
    }

    if (_selectedRole == null) {
      _showSnack(context, 'Please select a role');
      return;
    }

    _setLoading(true);

    try {
      final result = await AuthService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: confirmPassword,
        role: _selectedRole!,
      );

      final status = result['status'];
      final body = result['body'];

      if (status == 201) {
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

      if (status == 422 && body['errors'] != null) {
        final errors = body['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first[0];
        if(!context.mounted) return;
        _showSnack(context, firstError);
        return;
      }
      if(!context.mounted) return;
      _showSnack(context, body['message'] ?? 'Registration failed');
    } catch (e) {
      debugPrint('Registration error: $e');
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
        content: const Text('Registration successful!'),
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
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }
}
