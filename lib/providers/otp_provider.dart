import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../auth_services.dart';
import '../constants.dart';

class OtpProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  static const int otpLength = 5;

  bool isEmail(String input) {
    final emailRegex =
    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(input);
  }

  String getMaskedContact(String emailOrPhone) {
    final isEmailInput = isEmail(emailOrPhone);

    if (isEmailInput) {
      final parts = emailOrPhone.split('@');
      final username = parts[0];
      final masked = username.length > 2
          ? '${username[0]}${'*' * (username.length - 1)}'
          : username;
      return '$masked@${parts[1]}';
    } else {
      final digits = emailOrPhone.replaceAll(RegExp(r'\D'), '');
      return '${'*' * (digits.length - 4)}${digits.substring(digits.length - 4)}';
    }
  }

  Future<bool> verifyOtp({
    required String email,
    required String otp,
    required BuildContext context,
  }) async {
    if (otp.length < otpLength) {
      errorMessage = 'Please enter the full OTP';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await AuthService.verifyOTP(
        otp: otp,
        email: email,
      );

      final status = result['status'];
      final body = result['body'];

      if (status == 200) {
        if(!context.mounted) return false;
        _showSuccessDialog(context);
        return true;
      } else {
        errorMessage =
            body['message'] ?? 'OTP verification failed';
        return false;
      }
    } catch (_) {
      errorMessage = 'Server error. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> resend({ required String email }) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      return {
        'status': response.statusCode,
        'body': body,
      };
    } catch (e) {
      return {
        'status': 500,
        'body': {'message': 'Server error. Please try again.'},
      };
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }



  void _showSuccessDialog(BuildContext context) {
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Success'),
        content: const Text(
            'Verification successful!'
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(
          '/homePage',
      );
    });
  }

}
