import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'auth_services.dart';
import 'user_prefs.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  bool _isLoading = false;

  String? _selectedRole;

  static const List<String> _roles = [
    'player',
    'manager',
    'caddie',
  ];

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Registration successful!'),
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

  Future<void> _handleRegister() async {
    final name = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _passwordConfirmController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match. Please try again')),
      );
      return;
    }

    if (_selectedRole == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: confirmPassword,
        role: _selectedRole!,
      );

      if (!mounted) return;

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

        if (!mounted) return;
        _showDialog();
        return;
      }

      if (status == 422 && body['errors'] != null) {
        final errors = body['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first[0];

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(firstError)),
        );
        return;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(body['message'] ?? 'Registration failed')),
      );
    } catch (e) {
      debugPrint('Registration error: $e');
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

  String _formatRoleName(String role) {
    if (role == 'manager') return 'Course Manager';
    return role[0].toUpperCase() + role.substring(1);
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
              SizedBox.expand(
                child: Image.asset(
                  'images/registerpic.jpg',
                  fit: BoxFit.cover,
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.11),
                      child: Text(
                        'R E G I S T E R',
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
                                    controller: _fullNameController,
                                    hintText: 'Full Names',
                                    obscureText: false,
                                  ),

                                  SizedBox(height: height * 0.03),

                                  CustomTextField(
                                    controller: _emailController,
                                    hintText: 'Email',
                                    obscureText: false,
                                  ),

                                  SizedBox(height: height * 0.03),

                                  Container(
                                    height: 55,
                                    padding: EdgeInsets.only(right: width * 0.05),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        hint: Text(
                                          'Select role',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        value: _selectedRole,
                                        items: _roles.map((role) {
                                          return DropdownMenuItem<String>(
                                            value: role,
                                            child: Text(_formatRoleName(role)),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedRole = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: height * 0.03),

                                  CustomTextField(
                                    controller: _passwordController,
                                    hintText: 'Password',
                                    obscureText: true,
                                  ),

                                  SizedBox(height: height * 0.03),

                                  CustomTextField(
                                    controller: _passwordConfirmController,
                                    hintText: 'Confirm Password',
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
                                      onPressed: _isLoading ? null : _handleRegister,
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
                                        'Register',
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

                    // Login link
                    Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.04,
                        left: width * 0.05,
                        right: width * 0.05,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: Text(
                          'Already have an account? Login',
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
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }
}