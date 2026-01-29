import 'dart:ui';

import 'package:flutter/material.dart';
import 'auth_services.dart';
import 'constants.dart';
import 'user_prefs.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Log in successful!'),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/homePage',
                        (route) => false,
                  );
                }
              },
              child: const Text(
                'Ok',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.login(
        email: email,
        password: password,
      );

      if (!mounted) return;

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
        if (!mounted) return;
        _showDialog();
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      debugPrint('Login error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Server error. Please try again.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const TopBar(
        backgroundColor: Colors.transparent,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              // Background image
              SizedBox.expand(
                child: Image.asset(
                  'images/loginpic.jpg',
                  fit: BoxFit.cover,
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.11),
                      child: Text(
                        'L O G I N',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.045,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.05,
                        right: width * 0.05,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaY: 30, sigmaX: 30),
                          child: Container(
                            width: width * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                                vertical: height * 0.01,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(height: height * 0.03),

                                  CustomTextField(
                                    controller: _emailController,
                                    hintText: 'Email',
                                    obscureText: false,
                                  ),

                                  SizedBox(height: height * 0.03),

                                  CustomTextField(
                                    controller: _passwordController,
                                    hintText: 'Password',
                                    obscureText: true,
                                  ),

                                  SizedBox(height: height * 0.03),

                                  SizedBox(
                                    height: height * 0.05,
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Colors.white,
                                          width: 1.5,
                                        ),
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      onPressed: _isLoading ? null : _handleLogin,
                                      child: _isLoading
                                          ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                          : const Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: height * 0.03),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.02,
                        left: width * 0.05,
                        right: width * 0.05,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                        child: Text(
                          'Don\'t have an account? Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}